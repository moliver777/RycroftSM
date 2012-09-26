class AddHorseFieldsToClients < ActiveRecord::Migration
  def change
    add_column :clients, :leasing, :integer
    add_column :clients, :horses, :string
  end
end
