class AddFocToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :foc, :boolean, :default => false
  end
end
