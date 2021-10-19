class AddRebookedToBookings < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :rebooked, :boolean, :default => false
  end
end
