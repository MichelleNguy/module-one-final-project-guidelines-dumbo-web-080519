class Controller

    attr_reader :prompt
    attr_accessor :user

    
    @@prompt = TTY::Prompt.new(active_color: :red)
    

    def self.confirm(confirmation_message)
        @@prompt.select(confirmation_message) do |menu| 
            menu.choice "Yes", -> { true }
            menu.choice "No" , -> { false }
        end
    end

    def greet_user
        return_string = ""
        File.foreach("lib/welcome.txt") do |line|
            return_string += line
        end
        puts return_string.colorize(:light_black)
    end

    def login_menu
        @@prompt.select("Create an account or login to an existing one?") do |menu|
            menu.choice 'Login', -> { User.login_account }
            menu.choice 'Create account', -> { User.create_account}
        end
    end

    def clear?
        @@prompt.keypress("Press any key to continue.")
    end

    def main_menu
        user.display_account_info
        @@prompt.select("What would you like to view.") do |menu|
            menu.choice 'account setting', -> { self.user.send("account_settings") }
            menu.choice 'upcoming matches', -> { Match.send("upcoming", user)}
            menu.choice 'bet history', -> { self.user.send("bet_history") }
            menu.choice "exit application", -> { "exit"}
        end
    end

end
