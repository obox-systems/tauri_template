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