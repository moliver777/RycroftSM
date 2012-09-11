class AddConfirmToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :confirmed, :boolean, :default => false
  end
end
