#!/bin/bash
set -eux

# OpenJDK
if ! java -version &>/dev/null; then
  echo "Installing Open JDK..."
  
  OPEN_JDK=https://download.java.net/openjdk/jdk17/ri/openjdk-17+35_linux-x64_bin.tar.gz
  SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
  wget "$OPEN_JDK" -O openjdk.tar.gz
  tar -xzf openjdk.tar.gz -C /opt/
  rm openjdk.tar.gz
  update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 1
  update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 1
else
  echo "Open JDK is already installed."
fi

# Android SDK
if [ ! -d "$ANDROID_HOME/cmdline-tools/latest" ]; then
  echo 'export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"' >> /root/.bashrc
  
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
else
  echo "Android SDK is already installed."
fi

# Rust
if ! rustup show &>/dev/null; then
  rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android
else
  echo "Rust dependencies for adnroid are already installed"
fi

# Updating front dependencies
# cd /home/android/tauri-template
cd ./tauri-template-app
export PATH=$PATH:/usr/bin/versions/node/v22.13.0/bin
npm install
cd ..

# Tauri CLI
if ! cargo install --list | grep -q "tauri-cli"; then
  cargo install tauri-cli --version "^2.0.0" --locked
else
  echo "tauri-cli is already installed."
fi