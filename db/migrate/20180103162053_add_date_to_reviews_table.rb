class AddDateToReviewsTable < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :reviewed_date, :datetime
    add_column :reviews, :user_id, :integer
  end
end
