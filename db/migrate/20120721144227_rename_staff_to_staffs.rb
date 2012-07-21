class RenameStaffToStaffs < ActiveRecord::Migration
  def change
    rename_table :staff, :staffs
  end
end
