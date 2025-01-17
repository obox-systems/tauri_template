#!/bin/bash
set -eux

export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"
export PATH="/usr/bin/versions/node/v22.13.0/bin:$PATH"

cargo tauri android dev