class AddForColumnToBetsTable < ActiveRecord::Migration[5.0]
  def change
    add_column :bets, :for, :string
  end
end
