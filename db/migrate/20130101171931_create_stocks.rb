class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks, :force => true do |t|
      t.string :name
      t.string :description
      t.float :cost
      t.integer :quantity
      t.timestamps
    end

    add_column :payments, :stock_id, :integer
  end
end
