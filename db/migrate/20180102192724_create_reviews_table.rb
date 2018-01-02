class CreateReviewsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.string :content
    end 
  end
end
