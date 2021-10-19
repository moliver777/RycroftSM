class AddRebookIdToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :rebook_id, :integer
  end
end
