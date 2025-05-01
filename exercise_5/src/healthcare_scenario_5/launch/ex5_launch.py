import os

from ament_index_python.packages import get_package_share_directory

from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node

BOTS_MOVEMENT_DURATION = 2.0
BOTS_WITH_SOMETHING_MOVEMENT_DURATION = 3.0
SNAP_ACTIONS_DURATION = 1.0
LOADING_DURATION = 3.0
DELIVERING_DURATION = 2.0
FILLING_DURATION = 3.0


def generate_launch_description():
    # Get the launch directory
    example_dir = get_package_share_directory('healthcare_scenario_5')
    namespace = LaunchConfiguration('namespace')

    declare_namespace_cmd = DeclareLaunchArgument(
        'namespace',
        default_value='',
        description='Namespace')

    plansys2_cmd = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(os.path.join(
            get_package_share_directory('plansys2_bringup'),
            'launch',
            'plansys2_bringup_launch_monolithic.py')),
        launch_arguments={
            'model_file': example_dir + '/pddl/domain.pddl',
            'namespace': namespace,
        }.items())

    move_bot_cmd = Node(
        package='healthcare_scenario_5',
        executable='move_bot_node',
        name='move_bot_node',
        namespace=namespace,
        output='screen',
        parameters=[{
            "duration": BOTS_MOVEMENT_DURATION,
        }]
        )
    
    move_bot_with_carrier_cmd = Node(
        package='healthcare_scenario_5',
        executable='move_bot_with_carrier_node',
        name='move_bot_with_carrier_node',
        namespace=namespace,
        output='screen',
        parameters=[{
            "duration": BOTS_WITH_SOMETHING_MOVEMENT_DURATION,
        }]
        )
    
    attach_carrier_cmd = Node(
        package='healthcare_scenario_5',
        executable='attach_carrier_node',
        name='attach_carrier_node',
        namespace=namespace,
        output='screen',
        parameters=[{
            "duration": SNAP_ACTIONS_DURATION,
        }]
        )

    unattach_carrier_cmd = Node(
        package='healthcare_scenario_5',
        executable='unattach_carrier_node',
        name='unattach_carrier_node',
        namespace=namespace,
        output='screen',
        parameters=[{
            "duration": SNAP_ACTIONS_DURATION,
        }]
        )
    
    load_carrier_cmd = Node(
        package='healthcare_scenario_5',
        executable='load_carrier_node',
        name='load_carrier_node',
        namespace=namespace,
        output='screen',
        parameters=[{
            "duration": LOADING_DURATION,
        }]
        )

    unload_carrier_cmd = Node(
        package='healthcare_scenario_5',
        executable='unload_carrier_node',
        name='unload_carrier_node',
        namespace=namespace,
        output='screen',
        parameters=[{
            "duration": LOADING_DURATION,
        }]
        )

    fill_box_cmd = Node(
        package='healthcare_scenario_5',
        executable='fill_box_node',
        name='fill_box_node',
        namespace=namespace,
        output='screen',
        parameters=[{
            "duration": FILLING_DURATION,
        }]
        )

    deliver_aspirine_cmd = Node(
        package='healthcare_scenario_5',
        executable='deliver_aspirine_node',
        name='deliver_aspirine_node',
        namespace=namespace,
        output='screen',
        parameters=[{
            "duration": DELIVERING_DURATION,
        }]
        )
    
    deliver_scalpel_cmd = Node(
        package='healthcare_scenario_5',
        executable='deliver_scalpel_node',
        name='deliver_scalpel_node',
        namespace=namespace,
        output='screen',
        parameters=[{
            "duration": DELIVERING_DURATION,
        }]
        )

    deliver_tongue_depressor_cmd = Node(
        package='healthcare_scenario_5',
        executable='deliver_tongue_depressor_node',
        name='deliver_tongue_depressor_node',
        namespace=namespace,
        output='screen',
        parameters=[{
            "duration": DELIVERING_DURATION,
        }]
        )
    
    move_unit_cmd = Node(
        package='healthcare_scenario_5',
        executable='move_unit_node',
        name='move_unit_node',
        namespace=namespace,
        output='screen',
        parameters=[{
            "duration": BOTS_MOVEMENT_DURATION,
        }]
        )
    
    move_patient_with_unit_cmd = Node(
        package='healthcare_scenario_5',
        executable='move_patient_with_unit_node',
        name='move_patient_with_unit_node',
        namespace=namespace,
        output='screen',
        parameters=[{
            "duration": BOTS_WITH_SOMETHING_MOVEMENT_DURATION,
        }]
        )
    
    accompanies_patient_cmd = Node(
        package='healthcare_scenario_5',
        executable='accompanies_patient_node',
        name='accompanies_patient_node',
        namespace=namespace,
        output='screen',
        parameters=[{
            "duration": SNAP_ACTIONS_DURATION,
        }]
        )
    
    leave_patient_cmd = Node(
        package='healthcare_scenario_5',
        executable='leave_patient_node',
        name='leave_patient_node',
        namespace=namespace,
        output='screen',
        parameters=[{
            "duration": SNAP_ACTIONS_DURATION,
        }]
        )

    ld = LaunchDescription()

    ld.add_action(declare_namespace_cmd)
    # Declare the launch options
    ld.add_action(plansys2_cmd)

    # Added nodes
    ld.add_action(move_bot_cmd)
    ld.add_action(move_bot_with_carrier_cmd)
    ld.add_action(attach_carrier_cmd)
    ld.add_action(unattach_carrier_cmd)
    ld.add_action(load_carrier_cmd)
    ld.add_action(unload_carrier_cmd)
    ld.add_action(fill_box_cmd)
    ld.add_action(deliver_aspirine_cmd)
    ld.add_action(deliver_scalpel_cmd)
    ld.add_action(deliver_tongue_depressor_cmd)
    ld.add_action(move_unit_cmd)
    ld.add_action(move_patient_with_unit_cmd)
    ld.add_action(accompanies_patient_cmd)
    ld.add_action(leave_patient_cmd)

    return ld