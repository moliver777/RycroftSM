class ChangePaymentStockLinkField < ActiveRecord::Migration
  def change
    change_column :payments, :stock_id, :string
    rename_column :payments, :stock_id, :stock_ids
  end
end
