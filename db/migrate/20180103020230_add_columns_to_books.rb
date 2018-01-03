class AddColumnsToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :goodreads_id, :string
    add_column :books, :goodreads_url, :string
    add_column :books, :isbn, :string
    add_column :books, :page_count, :integer
    add_column :books, :publisher, :string
    add_column :books, :average_rating, :float
    add_column :books, :ratings_count, :integer
    add_column :books, :description, :text
  end
end
