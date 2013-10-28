class AddWelfareFieldsToHorses < ActiveRecord::Migration
  def change
    remove_column :horses, :heart_check
    remove_column :horses, :eyes_check
    remove_column :horses, :trot_up_check
    remove_column :horses, :tack_check_bridle
    remove_column :horses, :tack_check_saddle
    remove_column :horses, :tack_check_notes
    remove_column :horses, :physio_frequency
    remove_column :horses, :temp
    remove_column :horses, :pulse
    remove_column :horses, :respiration
    add_column :horses, :farrier_enabled, :boolean, :default => false, :null => false
    add_column :horses, :farrier_date, :date
    add_column :horses, :farrier_repeat, :integer, :default => 0, :null => false
    add_column :horses, :worming_enabled, :boolean, :default => false, :null => false
    add_column :horses, :worming_date, :date
    add_column :horses, :worming_repeat, :integer, :default => 0, :null => false
    add_column :horses, :dentist_enabled, :boolean, :default => false, :null => false
    add_column :horses, :dentist_date, :date
    add_column :horses, :dentist_repeat, :integer, :default => 0, :null => false
    add_column :horses, :physio_enabled, :boolean, :default => false, :null => false
    add_column :horses, :physio_date, :date
    add_column :horses, :physio_repeat, :integer, :default => 0, :null => false
    add_column :horses, :vaccination_enabled, :boolean, :default => false, :null => false
    add_column :horses, :vaccination_date, :date
    add_column :horses, :vaccination_repeat, :integer, :default => 0, :null => false
    add_column :horses, :other_enabled, :boolean, :default => false, :null => false
    add_column :horses, :other_date, :date
    add_column :horses, :other_repeat, :integer, :default => 0, :null => false
    add_column :horses, :other_comments, :string
  end
end
