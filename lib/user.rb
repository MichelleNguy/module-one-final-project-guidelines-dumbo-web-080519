class User < ActiveRecord::Base

    @@prompt = TTY:Prompt.new

    def self.prompt
        @@prompt
    end

    def login_account
        valid_account = validate_name(self.prompt.ask("What is your name?", required: true))
        if !valid_account
            self.prompt.say("Invalid account. Please enter an existing account.")
            login_account
        end
        valid_password = validate_password(self.prompt.ask("What is your password?", required: true), valid_account)
        if !valid_password 
            self.prompt.say("Invalid password.")
            login_account
        end
        valid_account
    end

    def valididate_name(name_to_validate)
        User.find_by(name: name_to_find)
    end

    def validate_password(password, user)
        user.password == password ? true : false
    end

    def create_account 

    end

end