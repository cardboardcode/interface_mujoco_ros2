# Use the official ROS 2 Humble base image
FROM ros:humble

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    build-essential \
    libgl1-mesa-dev \
    libglew-dev \
    libglfw3-dev \
    libosmesa6-dev \
    patchelf \
    python3 \
    python3-pip \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install mujoco-py dependencies
RUN pip3 install --no-cache-dir numpy cffi

# Create a directory for MuJoCo installation
WORKDIR /opt/mujoco

# Download and install MuJoCo binaries (replace URL with the latest version as needed)
RUN wget https://github.com/google-deepmind/mujoco/releases/download/3.2.6/mujoco-3.2.6-linux-x86_64.tar.gz && \
    tar -xvzf mujoco-3.2.6-linux-x86_64.tar.gz && \
    rm mujoco-3.2.6-linux-x86_64.tar.gz

# Set environment variables for MuJoCo
ENV MUJOCO_GL=egl
ENV LD_LIBRARY_PATH=/opt/mujoco/mujoco-3.2.6/bin:/opt/mujoco/mujoco-3.2.6/lib
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libGLEW.so

# Install mujoco-py
RUN git clone https://github.com/openai/mujoco-py.git /opt/mujoco-py && \
    pip3 install -e /opt/mujoco-py

# Install additional ROS 2 packages if needed
RUN apt-get update && \
    apt-get install -y --no-install-recommends ros-humble-rviz2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /ros2_ws
COPY . ./src/interface_mujoco_ros2/

# colcon compilation
RUN . /opt/ros/$ROS_DISTRO/setup.sh \
  && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release

# cleanup
RUN sed -i '$isource "/ros2_ws/install/setup.bash"' /ros_entrypoint.sh


# # Set the entrypoint for the container
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["ros2", "launch" ,"mujoco_interface", "velocity_mode.py"]
