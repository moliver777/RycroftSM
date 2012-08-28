class AddMasterVenueIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :master_venue_id, :integer
  end
end
