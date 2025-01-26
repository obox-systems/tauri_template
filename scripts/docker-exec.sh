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
  if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}\$"; then
    echo "Deleting existing container..."
    docker rm -f "$CONTAINER_NAME"
  fi

  echo "Building Dockerfile."
  docker build -t android-dev .

  echo "Running docker container."
  docker run \
           --device /dev/kvm \
           --name "$CONTAINER_NAME" \
           android-dev "$COMMAND_PATH"
else
  if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}\$"; then
    running=$(docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null)
    if [ "$running" = "true" ]; then
      echo "Container '$CONTAINER_NAME' is already running. Executing command..."
      docker exec "$CONTAINER_NAME" "$COMMAND_PATH"
    else
      echo "Container '$CONTAINER_NAME' is stopped (exited). Starting container..."
      docker start "$CONTAINER_NAME"
      docker exec "$CONTAINER_NAME" "$COMMAND_PATH"
    fi
  else
    echo "Container '$CONTAINER_NAME' does not exist. Please run with --build first."
    exit 1
  fi
fi