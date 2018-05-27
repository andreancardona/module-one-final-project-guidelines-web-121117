class AddDateToReviewsTable < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :reviewed_date, :datetime
    add_column :reviews, :book_id, :integer
    add_reference :reviews, :user, index: true, foreign_key: true
  end
end
