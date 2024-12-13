#!/usr/bin/env bash

source /opt/ros/humble/setup.bash
ros2 topic pub /joint_commands --once  std_msgs/msg/Float64MultiArray '{layout: {dim: [{label: "example", size: 3, stride: 3}], data_offset: 0}, data: ['$1', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]}'

