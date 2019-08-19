require "tty-prompt"

class Controller

    attr_reader :prompt

    def initialize
        @prompt = TTY::Prompt.new
    end

    def greet_user
        puts "hi!"
    end
    

end

controller = Controller.new

controller.greet_user

