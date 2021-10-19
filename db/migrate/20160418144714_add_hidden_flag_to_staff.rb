class AddHiddenFlagToStaff < ActiveRecord::Migration[5.2]
  def change
    add_column :staffs, :hidden, :boolean, null: false, default: false
  end
end
