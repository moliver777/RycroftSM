class AddWeeklyRepeatToNotes < ActiveRecord::Migration[5.2]
  def change
    add_column :notes, :weekly, :boolean, :default => false
    add_column :notes, :repeated, :boolean, :default => false
  end
end
