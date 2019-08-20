class Bet < ActiveRecord::Base
    belongs_to :users
    belongs_to :matches
end