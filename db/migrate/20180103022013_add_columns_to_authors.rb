class AddColumnsToAuthors < ActiveRecord::Migration[5.0]
  def change
    add_column :authors, :goodreads_id, :string
    add_column :authors, :goodreads_url, :string
  end
end
