#!/usr/bin/env bash

set -ex

cd "${0%/*}"


CONT=$(buildah from localhost/intrexx-portal-patch-container-base:latest)

buildah copy "$CONT" setup/ /setup


buildah run "$CONT" /bin/bash /setup/setup.sh
buildah run "$CONT" rm -rf /setup

buildah config --volume /build "$CONT"
buildah config --volume /setup-intrexx "$CONT"
buildah config --volume /portal "$CONT"
buildah config --volume /export "$CONT"

buildah config --cmd '/sbin/init' "$CONT"

buildah commit --rm "$CONT" localhost/intrexx-portal-patch-container:latest
