require_relative '../config/environment'

controller = Controller.new
controller.greet_user
user = controller.login_menu
choice = controller.main_menu

choice == "upcoming" ? Match.upcoming : user.send(choice)


binding.pry
0