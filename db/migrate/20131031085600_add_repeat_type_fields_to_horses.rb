class AddRepeatTypeFieldsToHorses < ActiveRecord::Migration[5.2]
  def change
    add_column :horses, :farrier_repeat_type, :string, :default => "week", :null => false
    add_column :horses, :worming_repeat_type, :string, :default => "week", :null => false
    add_column :horses, :dentist_repeat_type, :string, :default => "week", :null => false
    add_column :horses, :physio_repeat_type, :string, :default => "week", :null => false
    add_column :horses, :vaccination_repeat_type, :string, :default => "week", :null => false
    add_column :horses, :other_repeat_type, :string, :default => "week", :null => false
  end
end
