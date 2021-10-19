class AddStaffToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :staff_id, :integer
  end
end
