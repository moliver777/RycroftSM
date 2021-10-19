class AddPaymentDateToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :payment_date, :date
  end
end
