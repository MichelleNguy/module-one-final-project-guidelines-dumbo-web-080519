require_relative '../config/environment'

system "clear"
controller = Controller.new
controller.greet_user
controller.user = controller.login_menu

choice = nil
while choice != "exit"
    controller.user = User.find(controller.user.id)
    choice = controller.main_menu
end

binding.pry
0
