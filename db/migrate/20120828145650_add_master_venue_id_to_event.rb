class AddMasterVenueIdToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :master_venue_id, :integer
  end
end
