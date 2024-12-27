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

You can run macOS from Linux or Windows using `Docker-OSX`.

### How to start on Windows:

Ensure that you have Windows 11 installed.

Install [WSL](https://learn.microsoft.com/en-us/windows/wsl/) if you have not done it before. Run these commands from cmd
```bash
wsl --install
wsl --update
```

Then set up WSL distro by default:
```bash
# For example, 'wsl -d Ubuntu'
wsl -s <DistroName>

# Ensure that you have installed Linux distro
```

After WSL installation go to `C:/Users/Your_Name/.wslconfig` (Create if it doesn't exist) and add nestedVirtualization=true to the end of file. The result should be like this:
```bash
[wsl2]
nestedVirtualization=true
``` 

Run WSL
```bash
wsl
```


Install `cpu-checker` and then run `kvm-ok` to ensure that you can use kvm
```bash
# installing cpu-checker to be able run 'kvm-ok' command
sudo apt install cpu-checker

# Ensure that we can use kvm
kvm-ok
```

Your output should be like this:
```bash
INFO: /dev/kvm exists
KVM acceleration can be used
```

Now it is time to install [Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/) if you have not done it before.

After installation, go to Settings and check these 2 boxes:

```bash
General -> "Use the WSL2 based engine"
Resources -> WSL Integration -> "Enable integration with my default WSL distro"
```


Then, you'll need QEMU and some other dependencies on your host:
```bash
sudo apt install  \
  qemu-system  \
  qemu-kvm  \
  libvirt-clients  \
  libvirt-daemon-system  \
  bridge-utils  \
  virt-manager  \
  libguestfs-tools  \
  x11-apps -y
```

**! Pay Attention !**

Finally, you can run Docker to install macOS. There 

7. Finally, run Docker to install macOS:
```bash
docker run -i  \
 --device /dev/kvm  \
 -p 5999:5999  \
 -p 5998:5998  \
 -v /tmp/.X11-unix:/tmp/.X11-unix  \
 -e "DISPLAY=${DISPLAY:-:0.0}"  \
 -e EXTRA="-display none -vnc 0.0.0.0:99,password=on"  \
 -e GENERATE_UNIQUE=true  \
 -e CPU='Haswell-noTSX'  \
 -e RAM=6  \
 -e CPUID_FLAGS='kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on'  \
 -e MASTER_PLIST_URL='https://raw.githubusercontent.com/sickcodes/osx-serial-generator/master/config-custom-sonoma.plist'  \
 -e SHORTNAME=sonoma  \
 sickcodes/docker-osx:latest
```


**! IMPORTANT !** Before running docker with macOS make sure to allocate more than 4 GB RAM otherwise you will not be able to use [simulators](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device) for testing. 

You can also add more CPU if needed. To do this just add these lines after `docker run -it`.
```bash
# 10 GB of RAM and max CPU
-e RAM=10 \
-e cpu=max
```

### Troubleshooting

If you get an issue with GUI, [try this solution](https://www.youtube.com/watch?v=d9vK7H9P-V4), good luck!