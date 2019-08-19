class CreateBets < ActiveRecord::Migration[5.0]
  def change
    create_table :bets do |t|
      t.integer :user_id
      t.integer :match_id
      t.integer :amount
      t.string  :grade
      t.string  :status
      t.timestamp
    end
  end
end
