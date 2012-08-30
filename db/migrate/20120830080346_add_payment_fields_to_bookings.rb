class AddPaymentFieldsToBookings < ActiveRecord::Migration
  def change
    remove_column :bookings, :has_paid
    add_column :bookings, :cost, :float
  end
end
