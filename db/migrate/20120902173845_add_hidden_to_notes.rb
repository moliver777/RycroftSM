class AddHiddenToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :hidden, :boolean, :default => false
  end
end
