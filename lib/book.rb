class Book < ActiveRecord::Base
  belongs_to :author
  belongs_to :genre
  has_many :reviews

  def self.find_by_goodreads_search(title)
    results = RestClient.get("https://www.goodreads.com/search/index.xml?key=8dQUUUZ8wokkPMjjn2oRxA&q=#{title}")
    results_hash = Nokogiri::XML(results)
    results_hash.css("id")[1].text
  end

  def self.create_book_from_goodreads_id(goodreads_id)
    book = RestClient.get("https://www.goodreads.com/book/show/#{goodreads_id}.xml?key=8dQUUUZ8wokkPMjjn2oRxA")
    book_hash = Nokogiri::XML(book)
    author = Author.find_or_create_by_id(book_hash.css("author").css("id").first.text)
    title = book_hash.css("title").first.text
    isbn = book_hash.css("isbn").first.text
    published_date = book_hash.css("original_publication_year").first.text
    goodreads_id = book_hash.css("id").first.text
    goodreads_url = book_hash.css("link").first.text
    publisher = book_hash.css("publisher").first.text
    page_count = book_hash.css("num_pages").first.text
    description = book_hash.css("description").first.text
    average_rating = book_hash.css("average_rating").first.text
    ratings_count = book_hash.css("ratings_count").first.text
    genre = Book.find_best_genre(book_hash)
    Book.create(title: title, genre: genre, author: author, published_date: published_date, goodreads_id: goodreads_id, goodreads_url: goodreads_url, publisher: publisher, isbn: isbn, page_count: page_count, average_rating: average_rating, ratings_count: ratings_count, description: description)
  end

  def self.find_best_genre(book)
    # book = RestClient.get("#{book_instance.goodreads_url}?format=xml&key=8dQUUUZ8wokkPMjjn2oRxA")
    # book_hash = Nokogiri::XML(book) #converts to XML format 
    shelves_array = []
    book.css("shelf").first(5).each do |shelf_css|
      shelves_array << shelf_css.first[1]
    end
    correct_shelf = shelves_array.find do |shelf|
      !Genre.unwanted_shelves.include?(shelf)
    end
    # binding.pry
    Book.assign_genre_to_book(correct_shelf)
  end

  def self.assign_genre_to_book(shelf)
    if Genre.find_by name: shelf
      genre = Genre.find_by name: shelf
    else
      genre = Genre.create(name: shelf)
    end
    genre
  end
end
