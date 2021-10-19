class AddStaffNotesToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :staff_notes, :text
  end
end
