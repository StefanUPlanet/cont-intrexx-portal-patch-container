# Intrexx

Intrexx Portal Patch container.

## Services

- SSHD
- Postfix
- PostgreSQL
- Java 17 / Java 21

## Building the container image

```bash
git clone git@github.com:StefanUPlanet/cont-intrexx-portal-patch-container.git intrexx-portal-patch-container
cd intrexx-portal-patch-container
./build-base-image.sh
./build-image.sh
```

## Running the container

### Reguired Volumes

- /setup-intrexx

  Intrexx Setup, entweder entpackt in einem Verzeichnis o. als tar.gz

- /portal
  Das Portal das gepached werden soll. Verzeichnis, zip, tar, tar.gz

- /build

  Enthält entweder die ix-portal-updater-cleaner.jar oder das git repro:

  git clone von gitea@gitserver.dev.unitedplanet.de:stefanm/ix-portal-updater-cleaner.git

- /export

  Verzeichnis wo Portal export gespeichert werden soll

### Environment Variables

- NO_BUILD

  Wenn nicht gesetzt oder == "false" dann wird /build/gradle shadowJar zum erzeugen der ix-portal-updater-cleaner.jar angewendet.

Run the container, e.g. with

```bash
podman run --detach  --rm -v ./build:/build -v ./export:/export -v ./portal:/portal -v ./setup:/setup-intrexx --name portalPatch localhost/intrexx-portal-patch-container:latest
podman exec -it portalPatch /usr/bin/bash -c /tools/patchPortal.sh
```
