class AddNonBookingPaymentFields < ActiveRecord::Migration
  def change
    add_column :payments, :description, :string
    add_column :payments, :reference, :string
  end
end
