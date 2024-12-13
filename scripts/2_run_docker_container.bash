#!/usr/bin/env bash

xhost +local:docker

docker run -it --rm \
    --name interface_mujoco_ros2_c \
    --network host \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev/shm:/dev/shm \
    -v ./scripts:/ros2_ws/scripts \
interface_mujoco_ros2:latest
