echo "=============================="
vcs pull ~/
echo "=============================="
vcs import ~/argos_ws/src < argos.repos
echo "=============================="
cd ~/argos_ws
echo colcon build 
colcon build 
echo source install/setup.bash
source install/setup.bash