FROM rust:1.84

# Tauri System Dependencies
RUN apt-get update && apt-get install -y \
    sudo \
    libwebkit2gtk-4.1-dev \
    libsoup-3.0-dev \
    libjavascriptcoregtk-4.1-dev \
    build-essential \
    curl \
    wget \
    file \
    libxdo-dev \
    libssl-dev \
    libayatana-appindicator3-dev \
    librsvg2-dev \
    libxkbfile1 \
    libglu1-mesa \
    libpulse0 \
    libnss3 \
    libxi6 \
    libxrender1 \
    libxtst6 \
    libxcursor1 \
    libxrandr2 \
    unzip \
    openjdk-17-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN node -v && npm -v

# 4. Android SDK
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV ANDROID_HOME=/studio-data/Android
ENV PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH
ENV ANDROID_EMULATOR_USE_SYSTEM_LIBS=1

ARG SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
RUN mkdir -p $ANDROID_HOME/cmdline-tools \
    && wget "$SDK_URL" -O commandlinetools.zip \
    && unzip commandlinetools.zip -d $ANDROID_HOME/cmdline-tools \
    && rm commandlinetools.zip \
    && mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest \
    && yes | sdkmanager --licenses \
    && sdkmanager "platform-tools" \
                  "platforms;android-33" \
                  "build-tools;33.0.0" \
                  "ndk;25.2.9519653" \
                  "cmdline-tools;latest"

# Rust targets
RUN rustup target add aarch64-linux-android \
    armv7-linux-androideabi \
    i686-linux-android \
    x86_64-linux-android

# Tauri CLI
RUN cargo install tauri-cli --version "^2.0.0" --locked

# Copy source code
COPY . /home/android/tauri-template
COPY scripts/android/51-android.rules /etc/udev/rules.d/51-android.rules

# Copy scripts
COPY scripts/set-env.sh /usr/local/bin/set-env.sh
COPY scripts/android/build-apk.sh /usr/local/bin/build-apk.sh
COPY scripts/android/run-android.sh /usr/local/bin/run-android.sh
COPY scripts/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Make copied scripts runable
RUN chmod +x /usr/local/bin/set-env.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/run-android.sh
RUN chmod +x /usr/local/bin/build-apk.sh

WORKDIR /home/android/tauri-template

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]