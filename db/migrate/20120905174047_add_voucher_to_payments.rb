class AddVoucherToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :voucher, :boolean, :default => false
  end
end
