class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events, :force => true do |t|
      t.string :type
      t.text :description
      t.string :standard
      t.integer :venue_id
      t.date :event_date
      t.time :start_time
      t.time :end_time
      t.timestamps
    end
  end
end
