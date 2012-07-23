class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, :force => true do |t|
      t.string :username
      t.string :password
      t.string :first_name
      t.string :last_name
      t.string :user_level
      t.timestamps
    end

    add_index :users, [:username], :name => "index_users_on_username"
  end
end
