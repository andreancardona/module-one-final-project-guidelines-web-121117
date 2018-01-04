#@API_KEY = '8dQUUUZ8wokkPMjjn2oRxA'
# get book title
# author_hash.css("book").first.css("title").text

# get book goodreads page link
# author_hash.css("book").first.css("link").first.text

@unwanted_shelves = ["audiobooks", "novel", "novels", "1001-books", "nonfiction", "paulo-coelho", "to-read", "currently-reading", "sci-fi", "scifi", "favorites", "owned", "sf", "kindle", "audiobook", "default"]
def find_best_genre(book, bad_shelves = @unwanted_shelves)
  # book = RestClient.get("#{book_instance.goodreads_url}?format=xml&key=8dQUUUZ8wokkPMjjn2oRxA")
  # book_hash = Nokogiri::XML(book) #converts to XML format 
  shelves_array = []
  book.css("shelf").first(5).each do |shelf_css|
    shelves_array << shelf_css.first[1]
  end
  correct_shelf = shelves_array.find do |shelf|
    !bad_shelves.include?(shelf)
  end
  assign_genre_to_book(correct_shelf)
end

def assign_genre_to_book(shelf)
  if Genre.find_by name: shelf
    genre = Genre.find_by name: shelf
  else
    genre = Genre.create(name: shelf)
  end
  genre
end

def author_books_pages_count(books_count)
  bc = books_count.to_i
  if bc <= 30
    1
  elsif bc < 30 && bc <= 60
    2
  else
    3
  end
end

def create_book_from_url(url, author_instance)
  book = RestClient.get("#{url}?format=xml&key=8dQUUUZ8wokkPMjjn2oRxA")
  book_hash = Nokogiri::XML(book)
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
  genre = find_best_genre(book_hash)
  Book.create(title: title, genre: genre, author: author_instance,  published_date: published_date, goodreads_id: goodreads_id, goodreads_url: goodreads_url, publisher: publisher, isbn: isbn, page_count: page_count, average_rating: average_rating, ratings_count: ratings_count, description: description)
end

author_id_array = [545, 8132662, 1221698, 1214964, 6466154, 3389, 3565, 88506]

author_id_array.each do |author_id|
  # binding.pry
  author = RestClient.get("https://www.goodreads.com/author/show/#{author_id}?format=xml&key=8dQUUUZ8wokkPMjjn2oRxA")
  author_hash = Nokogiri::XML(author)
  author_name = author_hash.css("name").first.text
  author_goodreads_id = author_hash.css("id").first.text
  author_goodreads_url = author_hash.css("link").first.text
  author_instance = Author.create(name: author_name, goodreads_id: author_goodreads_id, goodreads_url: author_goodreads_url)

  author_books_pages = author_books_pages_count(author_hash.css("works_count").first.text)
  i = 0
  books_urls_array = []
  author_books_pages.times do
    i += 1
    books = RestClient.get("https://www.goodreads.com/author/list/#{author_id}?format=xml&page=#{i}&key=8dQUUUZ8wokkPMjjn2oRxA")
    books_hash = Nokogiri::XML(books)
    books_hash.css("book").each do |book|
      books_urls_array << book.children.css("link").first.text
    end
    books_urls_array.each do |url|
      create_book_from_url(url, author_instance)
    end
    books_urls_array = []
  end
end

kevin = User.get_user_data_from_goodreads_id(26666221)
User.find_or_create_user_from_hash(kevin)
andrea = User.get_user_data_from_goodreads_id(75948655)
User.find_or_create_user_from_hash(andrea)