#!/usr/bin/env bash

set -ex

cd "${0%/*}"

# this script requires four parameters


CONT=$(buildah from debian:trixie)

buildah copy $CONT setup/ /setup

buildah run $CONT /bin/bash /setup/setup-base.sh

buildah run $CONT rm -rf /setup

buildah commit --rm $CONT localhost/intrexx-portal-patch-container-base:latest
