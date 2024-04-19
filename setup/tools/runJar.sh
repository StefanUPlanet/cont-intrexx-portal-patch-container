#!/usr/bin/env bash

set -ex

cd "${0%/*}"

java -jar cleaner.jar $*
