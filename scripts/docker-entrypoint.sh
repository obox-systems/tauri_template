#!/bin/bash
set -eux

# OpenJDK
if ! command -v java >/dev/null 2>&1; then
  echo "Installing Java."
  OPEN_JDK=https://download.java.net/openjdk/jdk17/ri/openjdk-17+35_linux-x64_bin.tar.gz
  SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
  wget "$OPEN_JDK" -O openjdk.tar.gz
  tar -xzf openjdk.tar.gz -C /opt/
  rm openjdk.tar.gz
  update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 1
  update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 1
fi

# Android SDK
if [ ! -d "$ANDROID_HOME/cmdline-tools/latest" ]; then
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
fi

# Rust

MISSING_TARGETS=()

for target in aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android; do
  if ! rustup target list --installed | grep -q "^${target}\$"; then
    MISSING_TARGETS+=("$target")
  fi
done

if [ ${#MISSING_TARGETS[@]} -gt 0 ]; then
  echo "Installing missing targets: ${MISSING_TARGETS[@]}"
  rustup target add "${MISSING_TARGETS[@]}"
fi

# rustup target add aarch64-linux-android 
# rustup target add armv7-linux-androideabi 
# rustup target add i686-linux-android 
# rustup target add x86_64-linux-android

# Updating front dependencies
if [ -d "./tauri-template-app" ]; then
  pushd ./tauri-template-app >/dev/null 2>&1
  
  if [ -d "node_modules" ]; then
    echo "Node already installed in ./tauri-template-app/node_modules."
  else
    echo "Running npm install..."
    export PATH=$PATH:/usr/bin/versions/node/v22.13.0/bin
    npm install
  fi
  popd >/dev/null 2>&1
fi

# Tauri CLI
if cargo install --list | grep -q 'tauri-cli v2'; then
  echo "tauri-cli v2 already installed."
else
  echo "Installing tauri-cli v2..."
  cargo install tauri-cli --version "^2.0.0" --locked
fi

exec "$@"

# DEBUG_LOOP=1

# if [[ $DEBUG_LOOP != "" ]]; then
#   for (( ; ; ))
#    do
#       sleep 60s
#       echo "infinite loop for debug purposes"
#    done
# fi