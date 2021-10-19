class AddHoursToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :hours, :boolean, :default => false
  end
end
