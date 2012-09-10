class AddExtraStaffToEvents < ActiveRecord::Migration
  def change
    add_column :events, :staff_id2, :integer
    add_column :events, :staff_id3, :integer
  end
end
