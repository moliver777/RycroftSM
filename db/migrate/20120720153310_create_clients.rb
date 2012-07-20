class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients, :force => true do |t|
      t.string :first_name
      t.string :last_name
      t.string :standard
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :county
      t.string :country
      t.string :post_code
      t.string :home_phone
      t.string :mobile_phone
      t.string :emergency_contact_name
      t.string :emergency_contact_phone
      t.timestamps
    end
  end
end
