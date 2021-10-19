class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments, :force => true do |t|
      t.integer :booking_id
      t.boolean :cash, :default => false
      t.boolean :cc, :default => false
      t.boolean :cheque, :default => false
      t.float :amount, :default => 0.00
      t.timestamps
    end
  end
end
