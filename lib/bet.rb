class Bet < ActiveRecord::Base
    belongs_to :user
    belongs_to :match

    @@prompt = TTY::Prompt.new

    def display_info
        match = Match.find(self.match_id)
        puts "--------------------------------------------"
        puts "#{self.for.upcase} @ $#{self.amount}"
        puts "#{match.home_team.upcase} v. #{match.away_team.upcase}"
        #puts "You bet #{self.amount} on #{self.for} to win."
        puts "STATUS: #{self.status}"
        puts "--------------------------------------------"
    end

    def bet_menu
        display_info
        if self.status == "Pending"
            self.pending_menu
        else
            self.graded_menu
        end
    end

    def pending_menu
        @@prompt.select("What would you like to do?") do |menu|
          menu.choice "Cancel bet", -> {self.cancel_bet}
          menu.choice "Go back to main menu", -> {"main_menu"}
        end
    end

    def graded_menu
        @@prompt.select("What would you like to do?") do |menu|
        menu.choice "Go back to main menu", -> {"main_menu"}
      end
    end


    def cancel_bet
      puts "Bet has been cancelled."
      self.update(status: "Cancelled")
    end



end
