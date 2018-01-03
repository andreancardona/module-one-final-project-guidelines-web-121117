#@API_KEY = '8dQUUUZ8wokkPMjjn2oRxA'
# get book title
# author_hash.css("book").first.css("title").text

# get book goodreads page link
# author_hash.css("book").first.css("link").first.text

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
  # genre to be added here
  Book.create(title: title, author: author_instance,  published_date: published_date, goodreads_id: goodreads_id, goodreads_url: goodreads_url, publisher: publisher, isbn: isbn, page_count: page_count, average_rating: average_rating, ratings_count: ratings_count, description: description)
end

author_id_array = [545, 566, 8132662, 1221698, 1214964, 6466154, 3389, 3565, 88506]

author_id_array.each do |author_id|
  # binding.pry
  author = RestClient.get("https://www.goodreads.com/author/show/#{author_id}?format=xml&key=8dQUUUZ8wokkPMjjn2oRxA")
  author_hash = Nokogiri::XML(author)
  author_name = author_hash.css("name").first.text
  author_instance = Author.create(name: author_name)

  author_books_pages = author_books_pages_count(author_hash.css("works_count").first.text)
  i = 1
  books_hash = {}
  books_urls_array = []
  author_books_pages.times do 
    books = RestClient.get("https://www.goodreads.com/author/list/#{author_id}?format=xml&page=#{i}&key=8dQUUUZ8wokkPMjjn2oRxA")
    books_hash = Nokogiri::XML(books)
    books_hash.css("book").each do |book|
      # binding.pry
      books_urls_array << book.children.css("link").first.text
    end
    books_urls_array.each do |url|
      create_book_from_url(url, author_instance)
    end
    i = 0
    books_urls_array = []
  end
end
