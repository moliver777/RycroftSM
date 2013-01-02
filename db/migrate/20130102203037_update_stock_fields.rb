class UpdateStockFields < ActiveRecord::Migration
  def change
    change_column :stocks, :cost, :float, :default => 0.00, :null => false
    change_column :stocks, :quantity, :integer, :default => 0, :null => false
  end
end
