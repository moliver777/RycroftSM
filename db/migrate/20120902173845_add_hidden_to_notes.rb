class AddHiddenToNotes < ActiveRecord::Migration[5.2]
  def change
    add_column :notes, :hidden, :boolean, :default => false
  end
end
