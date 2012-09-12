class AddRebookedToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :rebooked, :boolean, :default => false
  end
end
