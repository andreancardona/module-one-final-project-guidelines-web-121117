class Review < ActiveRecord::Base
  belongs_to :book

  def self.get_user_reviews_from_goodreads(user)
    reviews = RestClient.get("https://www.goodreads.com/review/list_rss/#{user.goodreads_user_id}")
    reviews_hash = Nokogiri::XML(reviews)
    reviews_array = []
    reviews_hash.css("item").each { |r| reviews_array << r }
    reviews_array
  end

  def self.create_user_reviews_from_array(reviews_array, user)
    reviews_array.each do |review|
      review_data = Review.extract_data_from_hash(review)
      if Book.find_by(goodreads_id: review_data[1])
        Review.create(user_id: user.id, book: Book.find_by(goodreads_id: review_data[1]), rating: review_data[0], content: review_data[2])
      else
        Book.create_book_from_goodreads_id(review_data[1])
        Review.create(user_id: user.id, book: Book.find_by(goodreads_id: review_data[1]), rating: review_data[0], content: review_data[2])
      end
    end
  end

  def self.extract_data_from_hash(review_hash)
    data = []
    data << review_hash.css("user_rating").text
    data << review_hash.css("book_id").text
    data << review_hash.css("user_review").text
  end
end
