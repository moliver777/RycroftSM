class AddExtraStaffToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :staff_id2, :integer
    add_column :events, :staff_id3, :integer
  end
end
