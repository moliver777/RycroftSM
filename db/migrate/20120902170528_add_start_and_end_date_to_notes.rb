class AddStartAndEndDateToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :start_date, :date
    add_column :notes, :end_date, :date
  end
end
