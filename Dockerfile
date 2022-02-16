FROM ros:noetic

# install ros package
RUN apt-get update && apt-get install -y \
        libgl1-mesa-glx \
        libgl1-mesa-dri \
        libuvc-dev \
        ros-${ROS_DISTRO}-rgbd-launch \
        ros-${ROS_DISTRO}-libuvc-camera \
        ros-${ROS_DISTRO}-libuvc-ros

ENV ROS_WS /opt/ros_ws
RUN mkdir -p $ROS_WS/src
WORKDIR $ROS_WS

RUN mkdir -p $ROS_WS/src/ros_astra_camera
COPY . $ROS_WS/src/ros_astra_camera


RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    cd $ROS_WS && \
    catkin_make -DCATKIN_ENABLE_TESTING=0 -DCMAKE_BUILD_TYPE=Release

# clear ubuntu packages
RUN apt clean && rm -rf /var/lib/apt/lists/*

RUN sed --in-place --expression \
      '$isource "$ROS_WS/devel/setup.bash"' \
      /ros_entrypoint.sh

CMD ["roslaunch", "astra_camera", "embedded_s.launch"]
