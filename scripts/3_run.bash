#!/usr/bin/env bash

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/rosi/.mujoco/mujoco-3.2.6-linux-x86_64/mujoco-3.2.6/lib
source install/setup.bash

ros2 launch mujoco_interface velocity_mode.py
