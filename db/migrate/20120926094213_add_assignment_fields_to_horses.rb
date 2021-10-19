class AddAssignmentFieldsToHorses < ActiveRecord::Migration[5.2]
  def change
    add_column :horses, :group, :boolean, :default => true
    add_column :horses, :bhs, :integer, :default => 1
    add_column :horses, :livery, :boolean, :default => false
  end
end
