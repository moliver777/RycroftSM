class ChangePaymentStockLinkField < ActiveRecord::Migration[5.2]
  def change
    change_column :payments, :stock_id, :string
    rename_column :payments, :stock_id, :stock_ids
  end
end
