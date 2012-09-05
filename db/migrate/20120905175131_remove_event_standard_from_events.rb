class RemoveEventStandardFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :standard
  end
end
