FROM ros:humble-ros-base-jammy

# 環境変数を設定
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# universeリポジトリを有効化、基本ツール／ROS依存をまとめてインストール
RUN apt-get update && \
    apt-get install -y \
      software-properties-common \
      sudo \
      nano \
      wget \
      vim \
      git \
      python3-pip \
      openssh-client \
      x11-apps \
      libgl1-mesa-glx \
      libsm6 \
      libxext6 \
      libxrender1 \
      python3-colcon-common-extensions \
      python3-rosdep2 \
      python3-vcstool \
      v4l-utils \
      python3-roslaunch \
      ros-humble-cv-bridge \
      curl \
      ros-humble-desktop \
      libncurses5-dev \
      libncursesw5-dev \
      ros-humble-raspimouse \
      ros-humble-smach-ros \
      ros-humble-tf-transformations \
      ros-humble-nav2* \
      ros-humble-rclcpp \
      ros-humble-std-msgs \
      python3-rpi.gpio \
      python3-transitions \
      build-essential \
      ros-humble-raspimouse-description \
      ros-humble-rplidar-ros \
      ros-humble-cartographer* && \
    pip install --no-cache-dir opencv-contrib-python==4.6.0.66 && \
    echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc && \
    rosdep update
RUN apt-get install -y tree


# ユーザーを作成＆sudo権限付与
ARG UID GID GPIO_GID USER_NAME GROUP_NAME PASSWORD HOMEWORKSPACE
RUN groupadd gpio 2>/dev/null || true && \
    groupadd -g $GID $GROUP_NAME && \
    useradd -m -s /bin/bash \
      -u $UID -g $GID \
      -G sudo,video,gpio,dialout \
      $USER_NAME && \
    echo $USER_NAME:$PASSWORD | chpasswd && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USER_NAME
WORKDIR /home/$USER_NAME/$HOMEWORKSPACE

# ROSセットアップスクリプトを.bashrcに追記
RUN echo "source /opt/ros/humble/setup.bash" >> /home/$USER_NAME/.bashrc && \
    echo "source ~/$HOMEWORKSPACE/install/setup.bash" >> /home/$USER_NAME/.bashrc

# ホストの /proc 情報をマウントして Pi5 のボード情報を渡す
VOLUME ["/proc/device-tree", "/proc/cpuinfo"]

CMD ["bash"]
