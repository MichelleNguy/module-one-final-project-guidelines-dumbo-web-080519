class Match < ActiveRecord::Base
    has_many :bets
    has_many :users, through: :bets

    @@prompt = TTY::Prompt.new(active_color: :red)

    def self.ungraded_matches 
        self.all.select {|match| match.home_score == nil}
    end

    def self.pad_match_display(home, away, stadium, date)
        home = sprintf("%-15s", home)
        away = sprintf("%15s", away)
        stadium = sprintf("%-20s", stadium)
        "#{home} vs. #{away} | #{stadium} | #{date}"
    end

    def self.options_to_display
        matches = self.ungraded_matches.inject({}) do |hash, match|
            display = self.pad_match_display(match.home_team, match.away_team, match.stadium, match.date)
            hash[display] = match.id
            hash
        end
        matches["Return to main menu"] = "main menu"
        matches
    end

    def self.upcoming(user)
        match_id = @@prompt.select("Which match would you like to bet on?", self.options_to_display)
        return if match_id == "main menu"
        match = self.find(match_id)
        match.new_bet(user)
    end

    def new_bet(user)
        amount = @@prompt.ask("How much would you like to bet on this match?") do |q|
            q.required(true) 
            q.convert(:int)
            q.validate(/^[0-9]*$/)
            q.messages[:valid?] = "Please enter a valid amount."
        end
        if !user.can_bet?(amount)
            puts "Insufficent funds for wager."
            return self.new_bet(user)
        end
        user.change_funds(amount, "subtract")
        for_who = @@prompt.select("Who do you want to bet on?") do |who|
            who.choice(self.home_team)
            who.choice(self.away_team)
        end
        Bet.create(user_id: user.id, match_id: self.id, amount: amount, for: for_who, status: "Pending")
        @@prompt.say("Bet $#{amount} @ #{for_who} has been recorded.")
    end


end
