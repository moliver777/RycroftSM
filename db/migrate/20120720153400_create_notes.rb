class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes, :force => true do |t|
      t.string :title
      t.text :content
      t.boolean :urgent
      t.string :category
      t.integer :booking_id
      t.integer :client_id
      t.integer :horse_id
      t.integer :staff_id
      t.timestamps
    end
  end
end
