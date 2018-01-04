class AddDateToReviewsTable < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :reviewed_date, :datetime
    add_column :reviews, :user_id, :integer
    add_column :reviews, :book_id, :integer
  end
end
