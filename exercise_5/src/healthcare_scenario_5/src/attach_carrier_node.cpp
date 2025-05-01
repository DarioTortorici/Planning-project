#include <algorithm>
#include <memory>

#include "plansys2_executor/ActionExecutorClient.hpp"
#include "rclcpp/rclcpp.hpp"
#include "rclcpp_action/rclcpp_action.hpp"

using namespace std::chrono_literals;

class AttachCarrier : public plansys2::ActionExecutorClient
{
public:
  double duration;

  AttachCarrier()
      : plansys2::ActionExecutorClient(
            "attach_carrier",
            100ms)
  {
    progress_ = 0.0;
  }

private:
  void do_work()
  {
    if (progress_ < 1.0)
    {
      progress_ += 1 / (duration * 10);
      send_feedback(progress_, "attach_carrier running");
    }
    else
    {
      finish(true, 1.0, "attach_carrier completed");

      progress_ = 0.0;
      std::cout << std::endl;
    }

    std::cout << "\r\e[K" << std::flush;
    std::cout << "Requesting for attach the carrier... ["
              << std::min(100.0, progress_ * 100.0) << "%]  " << std::flush;
  }

  float progress_;
};

int main(int argc, char **argv)
{
  rclcpp::init(argc, argv);
  auto node = std::make_shared<AttachCarrier>();
  
  // declaration of the parameter and re-assign value 
  node->declare_parameter("duration", 1.0);
  node->duration = node->get_parameter("duration").as_double();

  node->set_parameter(rclcpp::Parameter("action_name", "attach_carrier"));
  node->trigger_transition(
      lifecycle_msgs::msg::Transition::TRANSITION_CONFIGURE);

  rclcpp::spin(node->get_node_base_interface());

  rclcpp::shutdown();

  return 0;
}