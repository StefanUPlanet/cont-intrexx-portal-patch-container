#!/usr/bin/env bash

export PATH=$PATH:/tools:/opt/gradle/bin:


sudo -u postgres psql -c "ALTER USER postgres PASSWORD '.admin1';" || exit 1


builder.sh
runJar.sh -c /tools/config.yaml
