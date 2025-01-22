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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Node.js
ARG NODE_URL=https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh
RUN curl -o- "$NODE_URL" | bash
RUN . ~/.nvm/nvm.sh && nvm install 22

ENV JAVA_HOME=/opt/jdk-17
ENV ANDROID_HOME=/studio-data/Android
ENV PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH
ENV ANDROID_EMULATOR_USE_SYSTEM_LIBS=1

COPY . /home/android/tauri-template
COPY scripts/android/51-android.rules /etc/udev/rules.d/51-android.rules

COPY scripts/set-env.sh /usr/local/bin/set-env.sh
COPY scripts/android/build-apk.sh /usr/local/bin/build-apk.sh
COPY scripts/android/run-android.sh /usr/local/bin/run-android.sh
COPY scripts/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/set-env.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/run-android.sh
RUN chmod +x /usr/local/bin/build-apk.sh

WORKDIR /home/android/tauri-template

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]