class Author < ActiveRecord::Base
  has_many :books
  has_many :reviews, through: :books
  has_many :genres, through: :books

  def self.find_or_create_by_id(goodreads_id)
    author = Author.find_by goodreads_id: goodreads_id
    if !author
      author = RestClient.get("https://www.goodreads.com/author/show/#{goodreads_id}?format=xml&key=8dQUUUZ8wokkPMjjn2oRxA")
      author_hash = Nokogiri::XML(author)
      author_name = author_hash.css("name").first.text
      author_goodreads_url = author_hash.css("link").first.text
      author = Author.create(name: author_name, goodreads_id: goodreads_id, goodreads_url: author_goodreads_url)
    end
    author
  end
end
