class CreateBooksTable < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :genre_id
      t.integer :author_id
      t.integer :published_date
    end 
  end
end
