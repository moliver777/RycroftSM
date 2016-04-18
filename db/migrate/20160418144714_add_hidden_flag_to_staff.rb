class AddHiddenFlagToStaff < ActiveRecord::Migration
  def change
    add_column :staffs, :hidden, :boolean, null: false, default: false
  end
end
