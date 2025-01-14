#!/bin/bash
set -eux

cd /home/android/tauri-template
cargo tauri android build --apk