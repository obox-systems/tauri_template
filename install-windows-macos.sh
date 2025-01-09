#!/usr/bin/env sh

## Default values
RAM=6
CPU='Haswell-noTSX'

## Handle cmd arguments
# Available: RAM and CPU
while [ $# -gt 0 ]; do
    case "$1" in
        -e)
            shift
            case "$1" in
                RAM=*)
                    RAM=${1#RAM=}
                    ;;
                CPU=*)
                    CPU=${1#CPU=}
                    ;;
                *)
                    echo "Unknown option: $1"
                    ;;
            esac
            ;;
        *)
            echo "$1 is not a valid option"
            ;;
    esac
    shift
done

## Installing all dependencies
sudo apt update && sudo apt install -y  \
    qemu-system  \
    qemu-kvm  \
    libvirt-clients \
    libvirt-daemon-system \
    bridge-utils \
    virt-manager \
    libguestfs-tools \
    x11-apps || { echo "Installation failed."; exit 1; }

echo "All dependencies were successfully installed!"

echo "Running docker..."
## Installing Docker Container
docker run -i  \
    --device /dev/kvm  \
    -p 5999:5999 -p 5998:5998  \
    -v /tmp/.X11-unix:/tmp/.X11-unix  \
    -e "DISPLAY=${DISPLAY:-:0.0}"  \
    -e EXTRA="-display none -vnc 0.0.0.0:99,password=on"  \
    -e GENERATE_UNIQUE=true  \
    -e CPU=$CPU  \
    -e RAM=$RAM  \
    -e CPUID_FLAGS='kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on'  \
    -e MASTER_PLIST_URL='https://raw.githubusercontent.com/sickcodes/osx-serial-generator/master/config-custom-sonoma.plist'  \
    -e SHORTNAME=sonoma  \
    sickcodes/docker-osx:latest