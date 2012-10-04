class AddCancelledToBookingsAndEvents < ActiveRecord::Migration
  def change
    add_column :events, :cancelled, :boolean, :default => false
    add_column :bookings, :cancelled, :boolean, :default => false
  end
end
