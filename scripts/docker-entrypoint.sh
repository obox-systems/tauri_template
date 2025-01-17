#!/bin/bash
set -eux

# OpenJDK
OPEN_JDK=https://download.java.net/openjdk/jdk17/ri/openjdk-17+35_linux-x64_bin.tar.gz
SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
wget "$OPEN_JDK" -O openjdk.tar.gz
tar -xzf openjdk.tar.gz -C /opt/
rm openjdk.tar.gz
update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 1
update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 1

# Android SDK
wget "$SDK_URL" -O commandlinetools.zip
mkdir -p $ANDROID_HOME/cmdline-tools
unzip commandlinetools.zip -d $ANDROID_HOME/cmdline-tools
rm commandlinetools.zip
mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest
yes | sdkmanager --licenses
sdkmanager "platform-tools" \
          "platforms;android-33" \
          "build-tools;33.0.0" \
          "ndk;25.2.9519653" \
          "cmdline-tools;latest"

# Rust
rustup target add aarch64-linux-android 
rustup target add armv7-linux-androideabi 
rustup target add i686-linux-android 
rustup target add x86_64-linux-android

# Updating front dependencies
cd ./tauri-template-app
export PATH=$PATH:/usr/bin/versions/node/v22.13.0/bin
npm install
cd ..

# Tauri CLI
cargo install tauri-cli --version "^2.0.0" --locked

# DEBUG_LOOP=1

# if [[ $DEBUG_LOOP != "" ]]; then
#   for (( ; ; ))
#    do
#       sleep 60s
#       echo "infinite loop for debug purposes"
#    done
# fi