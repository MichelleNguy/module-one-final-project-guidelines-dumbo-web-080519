class User < ActiveRecord::Base
    has_many :bets       
    has_many :matches, through: :bets

    @@prompt = TTY::Prompt.new

    def self.prompt
        @@prompt
    end

    def self.login_account
        valid_account = self.validate_name(self.prompt.ask("What is your name?", required: true).downcase)
        return self.invalid if !valid_account
        valid_password = self.validate_password(self.prompt.ask("What is your password?", required: true), valid_account)
        return self.invalid if !valid_password
        valid_account
    end

    def self.invalid 
        self.prompt.say("Invalid information! Try again.")
        self.login_account
    end

    def self.validate_name(name_to_validate)
        User.find_by(name: name_to_validate)
    end

    def self.validate_password(password, user)
        user.password == password ? true : false
    end

    def self.create_account 
        name_choice = self.prompt.ask("What name would you like to use?", required: true).downcase
        binding.pry
        search_for_name = self.validate_name(name_choice)
        if search_for_name 
            self.prompt.say("Unfortunately, an account with that name already exist. Please try again.")
            self.create_account
        end
        password = self.prompt.ask("What password would you like to use?", required: true)
        User.create(name: name_choice, password: password)
    end

    def account_settings
        puts "Hi, my name is #{self.name}"
    end

    def bet_history
        #grab bets and display in a nice way
        self.bets.each_with_index do |bet, i|
            @@prompt.say("#{i + 1}")
        end
    end

end