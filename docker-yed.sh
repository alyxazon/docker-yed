#!/bin/bash

# Generic settings
IMAGE_NAME="docker-yed"

# Display
XSOCK=/tmp/.X11-unix
XAUTH=$(mktemp /tmp/.docker.xauth-XXXXX)
xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

# Workspace
WS="workspace"
WS_LOCATION="$(pwd)/$WS"
WS_DOCKER="/home/yed/$WS"

# Time settings
TIME_LOCATION="/etc/localtime"
TIME_DOCKER=$TIME_LOCATION

# Function build
function build()
{
  mkdir -p $WS
  docker build \
    -t $IMAGE_NAME . \
    --build-arg YED_UID=$(id -u) \
    --build-arg YED_GID=$(id -g)
}

# Function run
function run()
{
  docker run \
    -t \
    -i \
    --rm \
    -v $TIME_LOCATION:$TIME_DOCKER:ro \
    -v $XSOCK:$XSOCK \
    -v $XAUTH:$XAUTH \
    -v $WS_LOCATION:/$WS_DOCKER \
    -e DISPLAY=unix$DISPLAY \
    -e XAUTHORITY=$XAUTH \
    "$IMAGE_NAME" "$@"
  rm $XAUTH
}

# Parse arguments
while getopts "br" opt; do
  case $opt in
    b)
      echo "Building container ..."
      build
      ;;
    r)
      echo "Running container ..."
      run
      ;;
    *)
      echo "Error: Invalid argument!"
      ;;
  esac
done
