# Intrexx

Intrexx Portal Patch container.

## Services

* SSHD
* Postfix
* PostgreSQL
* Java 17 / Java 21

The installation does not contain any portal.

## Base image

The base image is `localhost/debian-systemd:trixie`

The base image is provided by the [debian-systemd](https://github.com/veita/cont-debian-systemd)
project.

## Building the container image

```bash
git clone git@github.com:StefanUPlanet/cont-intrexx-portal-patch-container.git intrexx-portal-patch-container
cd intrexx-portal-patch-containerr
./build-base-image.sh
./build-image.sh
```

## Running the container

### Reguired Volumes

* /setup-intrexx

    Intrexx Setup, entweder entpackt in einem Verzeichnis o. als tar.gz

* /portal

    Das Portal das gepached werden soll. Verzeichnis, ZiP, tar, tar.gz

* /build

    Enthält entweder die ix-portal-updater-cleaner.jar oder das git repro:

    git clone von <gitea@gitserver.dev.unitedplanet.de>:stefanm/ix-portal-updater-cleaner.git

* /export

    Verzeichnis wo Portal export gespeichert werden soll

### Environment Variables

* NO_BUILD

    Wenn gesetzt und != "false" dann wird /build/gradle shadowJar zum erzeugen der ix-portal-updater-cleaner.jar angewendet und in /build das git
    repro gecloned wurde.

Run the container, e.g. with

```bash
podman run --rm -v ./build:/build -v ./export:/expot -v ./portal:/portal -v ./setup:/intrexx-setup ./localhost/intrexx-portal-patch-container:latest

```
