class AddPaymentFieldsToBookings < ActiveRecord::Migration[5.2]
  def change
    remove_column :bookings, :has_paid
    add_column :bookings, :cost, :float
  end
end
