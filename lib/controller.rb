class Controller

    attr_reader :prompt

    def initialize    
        @prompt = TTY::Prompt.new
    end

    def greet_user
        prompt.say("Welcome to AMBet!")
    end

    def login_menu
        prompt.select("Create an account or login to an existing one?") do |menu|
            menu.choice 'Login', -> { User.login_account }
            menu.choice 'Create account', -> { User.create_account}
        end
    end

end


