class RemoveEventStandardFromEvents < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :standard
  end
end
