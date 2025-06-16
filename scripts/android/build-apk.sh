#!/bin/bash
set -eux

# Setup enviroment
. /usr/local/bin/set-env.sh

cargo tauri android build --apk -d