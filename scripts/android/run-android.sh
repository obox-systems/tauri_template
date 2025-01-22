#!/bin/bash
set -eux

# Setup enviroment
. /usr/local/bin/set-env.sh

# Installing emulator dependencies
sdkmanager --install "system-images;android-33;google_apis;x86_64"
echo no | avdmanager create avd \
    --name testAVD \
    --package "system-images;android-33;google_apis;x86_64" \
    --abi google_apis/x86_64 \
    --device "pixel_4"

# Running emulator
emulator -avd testAVD \
         -no-snapshot \
         -netfast \
         -gpu swiftshader_indirect \
         -no-audio \
         -no-window