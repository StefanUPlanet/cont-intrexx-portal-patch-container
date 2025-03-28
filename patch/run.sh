#!/bin/bash

rm -rf portal/
mkdir portal
tar -xvf setup/setup.tar.gz -C portal  professional/orgtempl/blank
mv portal/professional/orgtempl/blank portal
rm -rf portal/professional


git clone gitea@gitserver.dev.unitedplanet.de:stefanm/ix-portal-updater-cleaner.git build/.
cd build
gradle shadowJar

cd .. 

podman run --replace  --detach  --rm -v ./build:/build -v ./export:/export -v ./portal:/portal -v ./setup:/setup-intrexx --name portalPatch localhost/intrexx-portal-patch-container:latest 
echo wait 2 sec
sleep 2
podman exec -it portalPatch /usr/bin/bash -c /tools/patchPortal.sh

