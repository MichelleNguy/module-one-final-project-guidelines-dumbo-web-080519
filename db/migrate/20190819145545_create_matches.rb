class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.string :stadium
      t.string :home_team
      t.string :away_team
      t.integer :home_score
      t.integer :away_score
      t.string :date
    end
  end
end
