class Controller

    attr_reader :prompt
    attr_accessor :user

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

    def main_menu
        prompt.select("What would you like to view.") do |menu|
            menu.choice 'account setting', -> { "account_settings" }
            menu.choice 'upcoming matches', -> { "upcoming"}
            menu.choice 'bet history', -> { "bet_history" }
        end
    end

end
