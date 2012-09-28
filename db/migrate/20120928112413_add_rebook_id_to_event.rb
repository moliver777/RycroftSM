class AddRebookIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :rebook_id, :integer
  end
end
