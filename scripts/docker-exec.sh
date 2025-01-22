#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <container_name> <command> [--build]"
  exit 1
fi

BUILD=0
CONTAINER_NAME=$1
COMMAND=$2
COMMAND_PATH="/usr/local/bin/run-android.sh"

if [[ "$COMMAND" != "run-android" && "$COMMAND" != "build-apk" ]]; then
  echo "Invalid command: $COMMAND. Valid commands are 'run-android' or 'build-apk'."
  exit 1
fi

if [[ "$COMMAND" == "build-apk" ]]; then
  COMMAND_PATH="/usr/local/bin/build-apk.sh"
fi

shift 2
while [ $# -gt 0 ]; do
  case "$1" in
    --build)
      BUILD=1
      ;;
    *)
      echo "$1 is not a valid option"
      exit 1
      ;;
  esac
  shift
done

if [ "$BUILD" -eq 1 ]; then

  echo "Building Dockerfile..."
  docker build -t android-dev .

fi

echo "Execute $COMMAND_PATH in $CONTAINER_NAME..."
docker run --rm \
           --device /dev/kvm \
           --name "$CONTAINER_NAME" \
           android-dev "$COMMAND_PATH"