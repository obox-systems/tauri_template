#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <container_name> <command> [--build]"
  exit 1
fi

CONTAINER_NAME=$1
COMMAND=$2
COMMAND_PATH="/usr/local/bin/run-android.sh"
BUILD=0


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
  if docker ps -a --filter "name=$CONTAINER_NAME" | grep -q "$CONTAINER_NAME"; then
    echo "Deleting old container..."
    docker rm -f "$CONTAINER_NAME"
  else
    echo "No existing container named $CONTAINER_NAME to delete."
  fi

  echo "Building Dockerfile..."
  docker build -t android-dev .

  echo "Running just built docker image..."
  docker run --name "$CONTAINER_NAME" android-dev
fi

if docker ps -a --filter "name=$CONTAINER_NAME" | grep -q "$CONTAINER_NAME"; then
  echo "Starting $CONTAINER_NAME ..."
  docker start "$CONTAINER_NAME"
else
  echo "Container $CONTAINER_NAME doesn't exist"
fi

echo "Execute $COMMAND_PATH in $CONTAINER_NAME..."
docker exec -it "$CONTAINER_NAME" sh -c "$COMMAND_PATH"