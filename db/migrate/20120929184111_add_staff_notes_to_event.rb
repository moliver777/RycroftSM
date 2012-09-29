class AddStaffNotesToEvent < ActiveRecord::Migration
  def change
    add_column :events, :staff_notes, :text
  end
end
