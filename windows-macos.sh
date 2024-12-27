#!/usr/bin/env sh

## Installing all dependencies
sudo apt update && sudo apt install -y  \
    qemu-system  \
    qemu-kvm  \
    libvirt-clients \
    libvirt-daemon-system \
    bridge-utils \
    virt-manager \
    libguestfs-tools \
    x11-apps || { echo "Installation failed. Please check logs."; exit 1; }

echo "Everything is installed!"