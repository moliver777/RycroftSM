class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings, :force => true do |t|
      t.integer :event_id
      t.integer :client_id
      t.integer :horse_id
      t.boolean :has_paid
      t.timestamps
    end
  end
end
