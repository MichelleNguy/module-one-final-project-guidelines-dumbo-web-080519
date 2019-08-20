require_relative '../config/environment'

controller = Controller.new
controller.greet_user
user = controller.login_menu
binding.pry


