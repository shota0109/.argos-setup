#!/bin/bash
set -e

# システム更新
sudo apt update && sudo apt upgrade -y

# VS Code インストール
sudo apt install -y software-properties-common apt-transport-https wget
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/packages.microsoft.gpg
echo "deb [arch=arm64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install -y code

# Chromium, Terminator
sudo apt install -y chromium-browser terminator

# 開発用依存関係
sudo apt install -y build-essential cmake git libbullet-dev libpython3-dev \
    python3-flake8 python3-pytest-cov python3-setuptools wget

# ROS 2 Humble + 追加パッケージ
sudo apt install -y curl
sudo apt update
sudo apt install -y ros-humble-desktop \
    python3-colcon-common-extensions python3-rosdep2 \
    ros-humble-cv-bridge ros-humble-raspimouse ros-humble-smach-ros \
    ros-humble-tf-transformations ros-humble-nav2* \
    ros-humble-rqt-image-view ros-humble-rqt-common-plugins \
    ros-humble-raspimouse-description ros-humble-rplidar-ros
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
rosdep update

# ワークスペースビルド
source /opt/ros/humble/setup.bash
rosdep install --from-paths src --ignore-src -r -y
colcon build --symlink-install
source install/setup.bash

# Python 用 OpenCV 環境再構築
sudo apt remove -y python3-opencv
sudo apt install -y python3-pip
pip3 install --upgrade pip
pip3 install scikit-build Cython wheel transforms3d
pip3 install opencv-contrib-python==4.8.1.78 numpy==1.23.5

# リポジトリ更新 & 再ビルド
cd ~/argos_ws/src/.argos-setup
./update.sh
rosdep install --from-paths src --ignore-src -r -y
cd ~/argos_ws
colcon build --symlink-install
source install/setup.bash


# #更新
# apt update && apt upgrade -y

# #アプリケーションのインストール
# #VScode
# apt install software-properties-common apt-transport-https wget -y
# wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
# install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
# sh -c 'echo "deb [arch=arm64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
# apt update
# apt install code -y

# #Chromium
# apt install -y chromium-browser

# #Terminator
# apt install -y terminator

# #依存関係
# apt install -y build-essential cmake git libbullet-dev libpython3-dev python3-flake8 python3-pytest-cov python3-setuptools wget

# #ROS2Humble
# apt-get install -y curl
# apt update
# apt install -y ros-humble-desktop
# echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
# apt install -y python3-colcon-common-extensions
# apt install -y python3-rosdep2
# rosdep update
# apt-get install -y ros-humble-cv-bridge libncurses5-dev libncursesw5-dev ros-humble-raspimouse ros-humble-smach-ros python3-vcstool
# apt install ros-humble-tf-transformations ros-humble-nav2* -y
# apt update
# apt install -y ros-humble-rqt-image-view
# apt install -y ros-humble-rqt-common-plugins

# apt update
# apt install -y ros-humble-raspimouse-description
# apt update
# apt install -y ros-humble-rplidar-ros



# rosdep update
# source /opt/ros/humble/setup.bash
# rosdep install --from-paths src --ignore-src -r -y
# colcon build
# source /opt/ros/humble/setup.bash

# #OpenCV
# apt remove -y python3-opencv
# apt install -y python3-pip
# pip install --upgrade pip
# pip3 install scikit-build Cython wheel transforms3d
# pip3 install opencv-contrib-python==4.8.1.78
# pip3 install numpy==1.23.5

# #リポジトリのクローン
# cd ~/argos_ws/src/.raspi5-setup
# ./update.sh

# rosdep install --from-paths src --ignore-src -r -y
# cd ~/argos_ws
# colcon build
# source install/setup.bash
