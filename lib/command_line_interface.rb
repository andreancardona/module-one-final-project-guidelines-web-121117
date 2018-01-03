class CommandLineInterface

  attr_accessor :session

  def initialize
    @session = nil
  end

  def greet
    puts "Welcome to MediocreReads, please enter your Goodreads user ID to login:"
    input = gets.chomp
    user_hash = User.get_user_data_from_goodreads_id(input)
    session.current_user = User.find_or_create_user_from_hash(user_hash)
    puts "Hi, #{session.current_user.name}, please select an option to continue."
    main_menu_options
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
      puts "Please enter a valid option"
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

  end

  def main_find_author_by_name
    puts "Please enter the author name you are searching for:"
    input = gets.chomp
    session.current_author = Author.all.find_by name: input
    if !session.current_author 
      new_author_id = Author.find_by_goodreads_search(input)
      session.current_author = Author.find_or_create_by_id(new_author_id)
    end
    author_menu_options
  end

  def author_menu_options
    author = session.current_author
    puts "#{author.name} currently has #{author.books.count} books in the MediocreReads database."
    puts "Average rating: #{author.average_books_rating} \/ 5   Most reviewed book: #{author.most_reviewed_books.last.title}\n\n"
    puts "Please select an option to continue:"
    puts "1. View this author's 3 highest rated books"
    parse_author_menu_input
  end

  def parse_author_menu_input
    input = gets.chomp
    case input
    when "1" then author_highest_rated_books
    #when "2" then main_find_author_by_name
    #when "3" then main_find_user_reviewed_books
    else
      puts "Please enter a valid option"
      parse_author_menu_input
    end
  end

  def author_highest_rated_books
    author = session.current_author
    book1 = author.most_reviewed_books[-1]
    book2 = author.most_reviewed_books[-2]
    book3 = author.most_reviewed_books[-3]
    puts "#{book1.title} - Total ratings: #{book1.ratings_count} Average rating: #{book1.average_rating}"
    puts "#{book2.title} - Total ratings: #{book2.ratings_count} Average rating: #{book2.average_rating}"
    puts "#{book3.title} - Total ratings: #{book3.ratings_count} Average rating: #{book3.average_rating}"
  end

end