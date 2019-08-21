class Match < ActiveRecord::Base
    has_many :bets
    has_many :users, through: :bets

    @@prompt = TTY::Prompt.new(active_color: :red)

    # def self.upcoming
    #     ungraded_matches = self.all.select {|match| match.home_score == nil}
    #     ungraded_matches.each_with_index do |match, i|
    #         puts "---------------------------------------".colorize(:light_black)
    #         puts "#{i + 1}| #{match.home_team.upcase} v. #{match.away_team.upcase} | #{match.stadium} | #{match.date}"
    #         puts "---------------------------------------".colorize(:light_black) if i == ungraded_matches.size - 1
    #     end
    # end

    def self.ungraded_matches 
        self.all.select {|match| match.home_score == nil}
    end

    def self.options_to_display
        matches = self.ungraded_matches.inject({}) do |hash, match|
            hash["#{match.home_team.upcase} v. #{match.away_team.upcase} | #{match.stadium} | #{match.date}"] = match.id
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
        amount = @@prompt.ask("How much would you like to bet on this match?", required: true, convert: :int)
        for_who = @@prompt.select("Who do you want to bet on?") do |who|
            who.choice(self.home_team)
            who.choice(self.away_team)
        end
        Bet.create(user_id: user.id, match_id: self.id, amount: amount, for: for_who, status: "Pending")
    end

end
