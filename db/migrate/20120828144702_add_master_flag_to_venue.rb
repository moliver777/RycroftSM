class AddMasterFlagToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :master, :boolean, :default => false
  end
end
