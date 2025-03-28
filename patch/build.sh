#!/bin/bash

if [ ! -d "setup" ]; then
    mkdir setup
else
    rm -rf setup
    mkdir setup
fi

if [ ! -d "export" ]; then
    mkdir export
else
    rm -rf export
    mkdir export
fi

if [ ! -d "build" ]; then
    mkdir build
else
    rm -rf build
    mkdir build
fi

if [ ! -d "export" ]; then
    mkdir export
else
    rm -rf export
    mkdir export
fi

if [ ! -d "tmp" ]; then
    mkdir tmp
else
    rm -rf tmp
    mkdir tmp
fi

if [ ! -d "portal" ]; then
    mkdir portal
else
    rm -rf portal
    mkdir portal
fi

dstSetup="$1"
portal="$2"
baseUrl="https://archive.intrexx.com/intrexx/tree"
user="$3"

if [ -z "$dstSetup" ]; then
    echo "Geb ein Setup an (URL für https://archive.intrexx.com/intrexx/tree/)"
    exit 1
fi

if [ -z "$user" ]; then
    echo "Benutzer nicht angegeben"
    exit 1
fi

if [ -z "$dstSetup" ]; then
    echo "Geb ein Setup an (URL für https://archive.intrexx.com/intrexx/tree/)"
    exit 1
fi

if [ -z "$portal" ]; then
    echo "Geb ein Setup von dem Portal an das blank portal gepachted werden soll (URL für https://archive.intrexx.com/intrexx/tree/)"
    exit 1
fi

set urlSetup=$dstSetup

if [[ $dstSetup =~ ^http ]]; then
    urlSetup=${dstSetup}
else
    if [[ $dstSetup =~ ^/ ]]; then
        urlSetup=${baseUrl}${dstSetup}
    else
        urlSetup=${baseUrl}/${dstSetup}
    fi
fi

urlPortal=""

if [[ $portal =~ ^http ]]; then
    urlPortal=${portal}
else
    if [[ $portal =~ ^/ ]]; then
        urlPortal=${baseUrl}${portal}
    else
        urlPortal=${baseUrl}/${portal}
    fi
fi

echo "Setup: $urlSetup"
echo "Portal: $urlPortal"
echo "User $user"

read -p "Möchten Sie fortfahren? (j/n): " answer

if [[ "$answer" =~ ^[Jj]$ ]]; then
    echo "Sie haben 'Ja' gewählt. Das Skript wird fortgesetzt."
else
    echo "Sie haben 'Nein' gewählt. Das Skript wird beendet."
    exit 1
fi

if [ ! -f "setup/setup.tar.gz" ]; then
    wget $urlSetup --user $user --ask-password   -O setup/setup.tar.gz

    if [ $? -ne 0 ]; then
        echo "Fehler beim Download des Setups"
        rm setup/setup.tar.gz
        exit 1
    fi
else
    echo "Setup bereits vorhanden"
fi


if [ ! -f "tmp/setup.tar.gz" ]; then
    wget $urlPortal --user $user --ask-password   -O tmp/setup.tar.gz

    if [ $? -ne 0 ]; then
        echo "Fehler beim Download des Portals"
        rm tmp/setup.tar.gz
        exit 1
    fi
else
    echo Portal bereits vorhanden
fi

./run.sh



