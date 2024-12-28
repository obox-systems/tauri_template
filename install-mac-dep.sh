#!/bin/bash

echo "Installing needed dependencies..."

## 1. Install brew if we don't have
if ! command -v brew &>/dev/null; then
  echo "Installing brew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

## 2. Install Node.js if we don't have
if ! command -v node &>/dev/null; then
  echo "Installing Node.js..."
  brew install node
fi

## 3. Install Xcode Command Tools if we don't have
if ! command -v xcode-select --print-path &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
fi

## 4. install Rust if we don't have and ensure that it added to PATH
if ! command -v rustup &>/dev/null; then
  echo "Installing Rust..."
  curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
  export PATH="$HOME/.cargo/bin:$PATH"
else 
  export PATH="$HOME/.cargo/bin:$PATH"
fi

echo "All dependencies were successfully installed!"
