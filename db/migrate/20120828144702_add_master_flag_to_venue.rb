class AddMasterFlagToVenue < ActiveRecord::Migration[5.2]
  def change
    add_column :venues, :master, :boolean, :default => false
  end
end
