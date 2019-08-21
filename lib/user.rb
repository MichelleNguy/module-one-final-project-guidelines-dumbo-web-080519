class User < ActiveRecord::Base
    has_many :bets
    has_many :matches, through: :bets

    @@prompt = TTY::Prompt.new

    # def self.prompt
    #     @@prompt
    # end

    def self.login_account
        valid_account = self.validate_name(@@prompt.ask("What is your name?", required: true).downcase)
        return self.invalid if !valid_account
        valid_password = self.validate_password(@@prompt.mask("What is your password?", required: true), valid_account)
        return self.invalid if !valid_password
        valid_account
    end

    def self.invalid
        @@prompt.say("Invalid information! Try again.")
        self.login_account
    end

    def self.validate_name(name_to_validate)
        User.find_by(name: name_to_validate)
    end

    def self.validate_password(password, user)
        user.password == password ? true : false
    end

    def self.create_account
        name_choice = @@prompt.ask("What name would you like to use?", required: true).downcase
        search_for_name = self.validate_name(name_choice)
        if search_for_name
            @@prompt.say("Unfortunately, an account with that name already exist. Please try again.")
            self.create_account
        end
        password = @@prompt.ask("What password would you like to use?", required: true)
        User.create(name: name_choice, password: password, funds: 0)
    end

    def account_settings
        self.display_account_info
        @@prompt.select("Options for account: #{self.name}") do |menu|
          menu.choice "add money to account?", -> {self.add_funds}
          menu.choice "change my password?", -> {self.change_password}
          menu.choice "delete account?", -> {self.delete_account}
          menu.choice "return to main menu", -> {"main_menu"}
        end
    end

    ## bets that are 'pending'
    def live_bets
        self.bets.select {|bet| bet.status == "Pending"}
    end

    ## total of all live bets
    def live_bets_total
        (self.live_bets.map {|bet| bet.amount }).sum
    end

    def display_account_info 
        ret = ""
        40.times { ret+= "-"}
        ret += "\nAccount: #{self.name} | Available: $#{self.funds}"
        ret += "\nTotal live bets: #{self.live_bets.count}"
        ret += "\nTotal in action: #{self.live_bets_total}\n"
        40.times { ret+= "-"}
        puts ret.colorize(:blue)
    end

    def add_funds
       amount = @@prompt.ask("How much would you like to add to your account?", required: true, validate: /\A\d{3}\Z/, convert: :int)
       self.change_funds(amount, "add")
       @@prompt.say("You have added $#{amount} to your account. The new balance is $#{self.funds}.")
    end

    def change_funds(amount, type)
        type == "add" ? self.update(funds: (self.funds += amount)) : self.update(funds: (self.funds -= amount))
    end

    def change_password
      changed_pass = @@prompt.ask("What is your new password?", required: true)
      self.update(password: changed_pass)
      @@prompt.say("Password has been changed.")
    end

    def delete_account
      self.destroy
      @@prompt.say("Your account has been deleted. Goodbye!")
      "exit"
    end

    def bet_history
        return puts "No bets to view." if self.bets.empty?
        bets = self.bets.inject({}) do |hash, bet|
            hash["#{bet.for} @$#{bet.amount} | #{bet.status}"] = bet.id
            hash
        end
        bet = Bet.find(@@prompt.select("Which bet would you like to view more info on?", bets))
        bet.bet_menu
    end

    def can_bet?(amount)
        self.funds >= amount ? true : false
    end


end
