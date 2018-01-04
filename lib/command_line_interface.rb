class CommandLineInterface

  attr_accessor :session

  def initialize
    @session = nil
  end

  def greet
    puts "Welcome to MediocreReads, please enter your user ID number to login, or type 'new' to create a new account:"
    User.list_users
    parse_greet_input
    puts "Hi, #{session.current_user.name}, please select an option to continue."
    main_menu_options
  end
  
  def parse_greet_input
    input = gets.chomp
    if input.downcase == "new"
      puts "A Goodreads account is required to create a new user account, please enter your Goodreads user ID:"
      goodreads_id = gets.chomp
      user_hash = User.get_user_data_from_goodreads_id(goodreads_id)
      session.current_user = User.find_or_create_user_from_hash(user_hash)
    elsif input.to_i.to_s == input
      session.current_user = User.find(input)
    elsif input.downcase == "exit"
      goodbye
    else
      puts "Please enter a valid command"
    end
  end

  def main_menu_options
    puts "1. Find a book by title"
    puts "2. Find an author by name"
    puts "3. Find your reviewed books"
    parse_main_menu_input
  end

  def parse_main_menu_input
    input = gets.chomp
    case input
    when "1" then main_find_book_by_title
    when "2" then main_find_author_by_name
    when "3" then main_find_user_reviewed_books
    else
      puts "Please enter a valid command"
      parse_main_menu_input
    end
  end

  def main_find_book_by_title
    puts "Please enter the book title you are searching for:"
    input = gets.chomp
    session.current_book = Book.all.find_by title: input
    if !session.current_book 
      new_book_id = Book.find_by_goodreads_search(input)
      session.current_book = Book.create_book_from_goodreads_id(new_book_id)
    end
    book_menu_options
  end

  def book_menu_options
    book = session.current_book
    puts "#{book.title} by #{book.author.name}, published #{book.published_date} by #{book.publisher}"
    puts "Average rating: #{book.average_rating} Total ratings: #{book.ratings_count}"
    puts "Summary: #{book.description}\n\n"
    puts "1. Open this book's Goodreads page"
  end

  def main_find_author_by_name
    puts "Please enter the author name you are searching for:"
    input = gets.chomp
    session.current_author = Author.all.find_by name: input
    unless session.current_author
      new_author_url = Author.find_url_by_goodreads_search(input)
      session.current_author = Author.create_by_goodreads_url(new_author_url)
    end
    author_menu_options
  end

  def author_menu_options
    author = session.current_author
    puts "#{author.name} currently has #{author.books.count} books in the MediocreReads database."
    puts "Average rating: #{author.average_books_rating} \/ 5   Most reviewed book: #{author.most_reviewed_books.last.title}\n\n"
    puts "Please select an option to continue:"
    puts "1. View this author's 3 highest rated books"
    puts "2. View this author's 3 most reviewed books"
    puts "3. Open this author's Goodreads page in your browser"
    puts "9. Log out"   
    puts "0. Exit"
    parse_author_menu_input
  end

  def parse_author_menu_input
    input = gets.chomp
    case input
    when "1" then author_highest_rated_books
    when "2" then author_most_reviewed_books
    when "3" then author_open_goodreads_page
    when "9", "logout" then logout
    when "0", "exit" then goodbye
    else
      puts "Please enter a valid option"
      parse_author_menu_input
    end
  end

  def author_highest_rated_books
    author = session.current_author
    books = author.books.order(average_rating: :desc)
    [1, 2, 3].each do |i|
      book = books[i]
      puts "#{book.title} - Total ratings: #{book.ratings_count} Average rating: #{book.average_rating}"
    end
    author_menu_options
  end

  def author_most_reviewed_books
    author = session.current_author
    [-3, -2, -1].each do |i|
      book = author.most_reviewed_books[i]
      puts "#{book.title} - Total ratings: #{book.ratings_count} Average rating: #{book.average_rating}"
    end
    author_menu_options
  end

  def author_open_goodreads_page
    system "open #{session.current_author.goodreads_url}"
    author_menu_options
  end

  def goodbye
    puts "Thank you for using MediocreReads, come back soon! Goodbye!"
  end

end