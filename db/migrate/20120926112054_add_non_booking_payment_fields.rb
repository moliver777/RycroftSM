class AddNonBookingPaymentFields < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :description, :string
    add_column :payments, :reference, :string
  end
end
