class AddHiddenFlagsToHorsesAndClients < ActiveRecord::Migration[5.2]
  def change
    add_column :horses, :hidden, :boolean, null: false, default: false
    add_column :clients, :hidden, :boolean, null: false, default: false
  end
end
