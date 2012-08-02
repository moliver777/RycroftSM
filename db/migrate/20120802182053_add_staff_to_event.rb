class AddStaffToEvent < ActiveRecord::Migration
  def change
    add_column :events, :staff_id, :integer
  end
end
