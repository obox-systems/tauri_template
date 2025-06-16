#!/bin/bash
set -eux

# Updating front dependencies
if [ -d "./tauri-template-app" ]; then
  pushd ./tauri-template-app >/dev/null 2>&1
  
  if [ -d "node_modules" ]; then
    echo "Node already installed in ./tauri-template-app/node_modules."
  else
    echo "Running npm install..."
    npm install
  fi

  popd >/dev/null 2>&1
fi

exec "$@"