cmake_minimum_required(VERSION 3.5)
project(healthcare_scenario_5)


find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(rclcpp_action REQUIRED)
find_package(plansys2_msgs REQUIRED)
find_package(plansys2_executor REQUIRED)

set(CMAKE_CXX_STANDARD 17)

set(dependencies
    rclcpp
    rclcpp_action
    plansys2_msgs
    plansys2_executor
)

add_executable(move_bot_node src/move_bot_node.cpp)
ament_target_dependencies(move_bot_node ${dependencies})

add_executable(move_bot_with_carrier_node src/move_bot_with_carrier_node.cpp)
ament_target_dependencies(move_bot_with_carrier_node ${dependencies})

add_executable(attach_carrier_node src/attach_carrier_node.cpp)
ament_target_dependencies(attach_carrier_node ${dependencies})

add_executable(unattach_carrier_node src/unattach_carrier_node.cpp)
ament_target_dependencies(unattach_carrier_node ${dependencies})

add_executable(load_carrier_node src/load_carrier_node.cpp)
ament_target_dependencies(load_carrier_node ${dependencies})

add_executable(unload_carrier_node src/unload_carrier_node.cpp)
ament_target_dependencies(unload_carrier_node ${dependencies})

add_executable(fill_box_node src/fill_box_node.cpp)
ament_target_dependencies(fill_box_node ${dependencies})

add_executable(deliver_aspirine_node src/deliver_aspirine_node.cpp)
ament_target_dependencies(deliver_aspirine_node ${dependencies})

add_executable(deliver_scalpel_node src/deliver_scalpel_node.cpp)
ament_target_dependencies(deliver_scalpel_node ${dependencies})

add_executable(deliver_tongue_depressor_node src/deliver_tongue_depressor_node.cpp)
ament_target_dependencies(deliver_tongue_depressor_node ${dependencies})

add_executable(move_unit_node src/move_unit_node.cpp)
ament_target_dependencies(move_unit_node ${dependencies})

add_executable(move_patient_with_unit_node src/move_patient_with_unit_node.cpp)
ament_target_dependencies(move_patient_with_unit_node ${dependencies})

add_executable(accompanies_patient_node src/accompanies_patient_node.cpp)
ament_target_dependencies(accompanies_patient_node ${dependencies})

add_executable(leave_patient_node src/leave_patient_node.cpp)
ament_target_dependencies(leave_patient_node ${dependencies})

install(DIRECTORY launch pddl DESTINATION share/${PROJECT_NAME})

install(TARGETS
  move_bot_node
  move_bot_with_carrier_node
  attach_carrier_node
  unattach_carrier_node
  load_carrier_node
  unload_carrier_node
  fill_box_node
  deliver_aspirine_node
  deliver_scalpel_node
  deliver_tongue_depressor_node
  move_unit_node
  move_patient_with_unit_node
  accompanies_patient_node
  leave_patient_node
  
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION lib/${PROJECT_NAME}
)

ament_export_dependencies(${dependencies})

ament_package()