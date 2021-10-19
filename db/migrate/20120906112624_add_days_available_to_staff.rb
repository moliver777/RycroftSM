class AddDaysAvailableToStaff < ActiveRecord::Migration[5.2]
  def change
    add_column :staffs, :monday, :boolean, :default => false
    add_column :staffs, :tuesday, :boolean, :default => false
    add_column :staffs, :wednesday, :boolean, :default => false
    add_column :staffs, :thursday, :boolean, :default => false
    add_column :staffs, :friday, :boolean, :default => false
    add_column :staffs, :saturday, :boolean, :default => false
    add_column :staffs, :sunday, :boolean, :default => false
  end
end
