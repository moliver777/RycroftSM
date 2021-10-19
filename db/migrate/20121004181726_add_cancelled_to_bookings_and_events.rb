class AddCancelledToBookingsAndEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :cancelled, :boolean, :default => false
    add_column :bookings, :cancelled, :boolean, :default => false
  end
end
