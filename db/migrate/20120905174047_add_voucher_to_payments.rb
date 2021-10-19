class AddVoucherToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :voucher, :boolean, :default => false
  end
end
