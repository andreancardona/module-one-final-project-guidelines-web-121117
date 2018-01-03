class CommandLineInterface
  def greet(session)
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
    current_book = Book.all.find_by title: input
    if !current_book 
      new_book_id = Book.find_by_goodreads_search(input)
      current_book = Book.create_book_from_goodreads_id(new_book_id)
    end
  end

  

end