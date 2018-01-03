class AddDateToReviewsTable < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :reviewed_date, :datetime
  end
end
