#!/usr/bin/env bash

set -ex

cd "${0%/*}"

# this script requires four parameters

SUITE="${1:-trixie}"

CONT=$(buildah from localhost/debian-systemd-${SUITE}:latest)

buildah copy $CONT setup/ /setup

buildah run $CONT /bin/bash /setup/setup-base.sh

buildah run $CONT rm -rf /setup

buildah commit --rm $CONT localhost/intrexx-portal-patch-container-base:latest
