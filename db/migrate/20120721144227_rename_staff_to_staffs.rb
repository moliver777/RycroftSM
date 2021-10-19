class RenameStaffToStaffs < ActiveRecord::Migration[5.2]
  def change
    rename_table :staff, :staffs
  end
end
