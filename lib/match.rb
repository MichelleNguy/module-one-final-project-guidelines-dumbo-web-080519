class Match < ActiveRecord::Base
    has_many :bets
    has_many :users, through: :bets

    def self.upcoming
        ungraded_matches = self.all.select {|match| match.home_score == nil}
        ungraded_matches.each_with_index do |match, i|
            puts "#{i + 1}. #{match.home_team} will play against #{match.away_team} in #{match.stadium} on #{match.date}"
        end
        #return to main menu
    end

end
