class AddUsersTable < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :goodreads_user_id
      t.string :goodreads_user_url
    end
  end
end
