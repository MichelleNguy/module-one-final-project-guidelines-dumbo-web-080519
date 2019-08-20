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
        @@prompt.select("Hi, my name is #{self.name}") do |menu|
          menu.choice "I would like to add money to my account?", -> {self.add_funds}
          menu.choice "I would like to change my password?", -> {self.change_password}
          menu.choice "I would like to delete my account?", -> {self.delete_account}
          menu.choice "Go back to main menu", -> {"main_menu"}
        end
    end

    def add_funds
       amount = @@prompt.ask("How much would you like to add to your account?", required: true, validate: /\A\d{3}\Z/, convert: :int)
       new_amount = self.funds + amount
       self.update(funds: new_amount)
       @@prompt.say("You have added $#{amount} to your account. The new balance is $#{new_amount}.")
    end

    def change_password
      changed_pass = @@prompt.ask("What is your new password?")
      self.update(password: changed_pass)
    end

    def delete_account
      self.destroy
      puts "Your account has been deleted."
    end

    def bet_history
        bets = self.bets.inject({}) do |hash, bet|
            hash["$#{bet.amount} on #{bet.for} to win"] = bet.id
            hash
        end
        bet = Bet.find(@@prompt.select("Choose your destiny?", bets))
        bet.bet_menu
    end

end
