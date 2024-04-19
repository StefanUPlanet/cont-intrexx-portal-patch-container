#!/usr/bin/env bash

whoami

cd /build || exit

source /root/.bashrc

if [ -f "ix-portal-updater-cleaner.jar" ]
then
    cp ix-portal-updater-cleaner.jar  /tools/cleaner.jar
else
    noBuild="${NO_BUILD:-false}"

    if [ "false" == "$noBuild" ]
    then
        gradle --no-daemon shadowJar
    fi

    cp deliverables/ix-portal-updater-cleaner.jar  /tools/cleaner.jar
fi