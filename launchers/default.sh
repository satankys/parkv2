#!/bin/bash
set -e

# ROS environment ko set up karta hai
source /workspace/catkin_ws/devel/setup.bash

# Global ROS Parameter 'demo_name' ko set karo
rosparam set /$VEHICLE_NAME/demo_name indefinite_navigation

# Ab launch file ko start karo
roslaunch parking parking.launch veh:=$VEHICLE_NAME

# Keep the container running
exec "$@"
