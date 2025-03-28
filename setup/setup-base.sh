#!/usr/bin/env bash
#!/bin/bash

set -ex

export DEBIAN_FRONTEND=noninteractive

apt-get update -qy
apt-get upgrade -qy
apt-get install -qy systemd systemd-sysv sudo locales lsb-release wget curl \
                    gnupg2 less vim screen ripgrep tree unzip htop \
                    git mc imagemagick openjdk-21-jdk openjdk-21-jre openjdk-17-jdk openjdk-17-jre \
                    nano

# cleanup Systemd configuration
rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    /lib/systemd/system/systemd-update-utmp*

# install SSH
apt-get install -y openssh-server

# configure sshd
if [ -f /root/.ssh/authorized_keys ]; then
    sed -i 's|#PermitRootLogin prohibit-password|PermitRootLogin prohibit-password|g' /etc/ssh/sshd_config
else
    sed -i 's|#PermitRootLogin prohibit-password|PermitRootLogin yes|g' /etc/ssh/sshd_config

    # set the root password to admin
    echo 'root:admin' | chpasswd
fi

sed -i 's/#MaxAuthTries [0-9]\+/MaxAuthTries 32/g' /etc/ssh/sshd_config

# services
systemctl enable ssh.service

# regenerate host key on container startup
mkdir /etc/systemd/system/sshd.service.d

cat << EOF > /etc/systemd/system/sshd.service.d/regenerate-host-keys.conf
[Service]
ExecStartPre=/bin/bash -c '/bin/rm /etc/ssh/ssh_host_* || :'
ExecStartPre=/usr/sbin/dpkg-reconfigure --frontend=noninteractive openssh-server
ExecStartPre=/bin/rm -rf /etc/systemd/system/sshd.service.d
EOF

chmod 644 /etc/systemd/system/sshd.service.d/regenerate-host-keys.conf

# system configuration: locales
echo 'de_DE.UTF-8 UTF-8' >> /etc/locale.gen
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
/usr/sbin/locale-gen

# global shell configuration
sed -i 's/# "\\e\[5~": history-search-backward/"\\e\[5~": history-search-backward/g' /etc/inputrc
sed -i 's/# "\\e\[6~": history-search-forward/"\\e\[6~": history-search-forward/g' /etc/inputrc

sed -i 's|SHELL=/bin/sh|SHELL=/bin/bash|g' /etc/default/useradd

sed -i 's|#force_color_prompt=yes|force_color_prompt=yes|g' /etc/skel/.bashrc

source /setup/user-bashrc.sh >> /etc/skel/.bashrc

# global vim configuration
sed -i 's|"syntax on|syntax on|g' /etc/vim/vimrc
sed -i 's|"set background=dark|set background=dark|g' /etc/vim/vimrc

# global screen configuration
sed -i 's|#startup_message off|startup_message off|g' /etc/screenrc
echo 'shell /bin/bash' >> /etc/screenrc

# shell settings for root
source /setup/root-bashrc.sh >> /root/.bashrc

# vim settings for root
echo 'set mouse-=a' > /root/.vimrc


# Postfix is needed to prevent excessive package pulls (Exim etc.) later
debconf-set-selections <<< "postfix postfix/mailname string 'localhost'"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Local only'"

apt-get install -qy postfix

# install and configure PostgreSQL
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ trixie-pgdg main" >> /etc/apt/sources.list

apt-get update -qy
apt-get install -qy postgresql

sed -i 's/^port.*$/port = 5432/g' /etc/postgresql/*/main/postgresql.conf
#sed -i -r 's/(.*127\.0\.0\.1\/32\s+)md5$/\1trust/g' /etc/postgresql/*/main/pg_hba.conf
#sed -i -r 's/(.*::1\/128\s+)md5$/\1trust/g' /etc/postgresql/*/main/pg_hba.conf
#sed -i -r 's/(.*127\.0\.0\.1\/32\s+)scram-sha-256$/\1trust/g' /etc/postgresql/*/main/pg_hba.conf
#sed -i -r 's/(.*::1\/128\s+)scram-sha-256$/\1trust/g' /etc/postgresql/*/main/pg_hba.conf

$(shopt -s dotglob ; cp /etc/skel/* /var/lib/postgresql/)

# services
systemctl enable postfix
systemctl enable postgresql

#install gradle 8.6

if [ -d '/tmp-gradle' ]
then
    rm -rf /tmp-gradle
fi

gradleV="8.13"
mkdir /tmp-gradle
cd /tmp-gradle
wget https://services.gradle.org/distributions/gradle-${gradleV}-bin.zip

unzip gradle-${gradleV}-bin.zip

mv gradle-${gradleV} /opt/gradle

echo "export PATH=/opt/gradle/bin:${PATH}" | tee /etc/profile.d/gradle.sh

chmod +x /etc/profile.d/gradle.sh

source /etc/profile.d/gradle.sh

gradle -v

cd /

rm -rf /tmp-gradle


# cleanup
apt-get clean -qy
apt-get autoremove -qy


# modify .bashrc for root
cat << EOF >> /root/.bashrc

alias p='cd /opt/intrexx/org/*/'
alias pl='less /opt/intrexx/org/*/log/portal.log'
EOF

# cleanup
rm -rf /tmp/* /var/tmp/*

# cleanup
source /setup/cleanup-image.sh

