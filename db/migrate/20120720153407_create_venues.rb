class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues, :force => true do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
  end
end
