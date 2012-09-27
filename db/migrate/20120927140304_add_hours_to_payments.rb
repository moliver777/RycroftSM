class AddHoursToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :hours, :boolean, :default => false
  end
end
