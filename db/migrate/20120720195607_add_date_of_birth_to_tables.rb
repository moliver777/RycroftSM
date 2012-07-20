class AddDateOfBirthToTables < ActiveRecord::Migration
  def change
    add_column :clients, :date_of_birth, :date
    add_column :staff, :date_of_birth, :date
  end
end
