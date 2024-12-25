# Tauri template

Template uses typescript with vanilla flavour for UI.

## Recommended IDE Setup

- [VS Code](https://code.visualstudio.com/) + [Tauri](https://marketplace.visualstudio.com/items?itemName=tauri-apps.tauri-vscode) + [rust-analyzer](https://marketplace.visualstudio.com/items?itemName=rust-lang.rust-analyzer)

## Prerequisites

### Tauri

See tauri [prerequisites](https://v2.tauri.app/start/prerequisites/).

*Note*: you required to install [node.js](https://nodejs.org/en). After that you need to run:

```bash
cd ./tauri-template-app
npm install
cd ..
```

This will install all required node dependencies which is required step before you build your app.

### Cargo plugin

This plugin required to build project.

```bash
cargo install tauri-cli --version "^2.0.0" --locked
```

### Android

Download and install Android Studio from official [website](https://developer.android.com/studio).

Then [configure](https://v2.tauri.app/start/prerequisites/#android) environment for Tauri and Android Studio.

### IOS

You need Xcode and cocoapods installed

*Note*: run this command to install cocoapods
```bash
brew install cocoapods
```

## Run project

Run this command from project root(`./tauri-template-app`)

```bash
cargo tauri dev 
```

## You don't have macOS to develop on IOS?

You can run macOS from Linux or Windows using [Docker-OSX](https://github.com/sickcodes/Docker-OSX?tab=readme-ov-file#quick-start-docker-osx).

**! IMPORTANT !** Before running docker with macOS make sure to allocate more than 4 GB RAM otherwise you will not be able to use [simulators](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device) for testing. 

You can also add more CPU if needed. To do this just add these lines after `docker run -it`.
```bash
# 10 GB of RAM and max CPU
-e RAM=10 \
-e cpu=max
```

### Troubleshooting

If you get an issue with GUI, [try this solution](https://www.youtube.com/watch?v=d9vK7H9P-V4), good luck!