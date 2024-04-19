#!/usr/bin/bash

set -ex

export DEBIAN_FRONTEND=noninteractive

source /etc/profile.d/gradle.sh

echo "export PATH=$PATH:/opt/gradle/bin:/tools" >> /root/.bashrc

mkdir /setup-intrexx
mv /setup/tools /

chmod +x /tools/*.sh
mkdir /portal
mkdir /export
mkdir /build
mkdir /intrexx-tmp


