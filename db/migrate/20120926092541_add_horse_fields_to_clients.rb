class AddHorseFieldsToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :leasing, :integer
    add_column :clients, :horses, :string
  end
end
