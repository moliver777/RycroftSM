class AddFocToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :foc, :boolean, :default => false
  end
end
