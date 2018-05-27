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
      parse_greet_input
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
    unless session.current_book
      puts "#{input} not found in database, would you like to add it from Goodreads? (y/n)"
      choice = gets.chomp.downcase
      if choice == "y"
        new_book_id = Book.find_by_goodreads_search(input)
        session.current_book = Book.create_book_from_goodreads_id(new_book_id)
      else
        main_menu_options
      end
    end
    book_menu_options
  end

  def book_menu_options
    book = session.current_book
    puts "#{book.title} by #{book.author.name}, published #{book.published_date} by #{book.publisher}"
    puts "Average rating: #{book.average_rating} Total ratings: #{book.ratings_count}"
    puts "Summary: #{book.description}\n\n"
    puts "1. Open #{book.title}'s Goodreads page"
    puts "2. View or add your review for #{book.title}"
    puts "Enter 'logout' to log out of your account or 'exit' to exit MediocreReads"
    parse_book_menu_input
  end

  def parse_book_menu_input
    input = gets.chomp.downcase
    case input
    when "1" then
      system "open #{session.current_book.goodreads_url}"
      puts "Enter 'back' to go to the previous menu or '2' to view or add a review for this book"
      parse_book_menu_input
    when "2" then find_or_add_review
    when "logout" then logout
    when "exit" then goodbye
    when "back"
      session.current_book = nil
      main_menu_options
    else
      puts "Please enter a valid option"
      parse_book_menu_input
    end
  end

  def find_or_add_review
    review = Review.find_by user_id: session.current_user.id, book_id: session.current_book.id
    if review
      puts "\n#{review.book.title} by #{review.book.author.name}, published #{review.book.published_date}"
      puts "Your rating: #{review.rating}   Average rating: #{review.book.average_rating} from #{review.book.ratings_count} reviews"
      puts "Your review: #{review.content}\n\n"
    else
      puts "You have not reviewed this book yet, would you like to add a review? (y/n)"
      choice = gets.chomp.downcase
      if choice == "y"
        puts "Please enter your rating from 1-5:"
        rating = gets.chomp
        puts "(Optional) Enter your comments for this review:"
        content = gets.chomp
        Review.create(book_id: session.current_book.id, user_id: session.current_user.id, rating: rating, content: content, reviewed_date: Time.now)
      else
        book_menu_options
      end
    end
    book_menu_options
  end

  def main_find_author_by_name
    puts "Please enter the author name you are searching for:"
    input = gets.chomp
    session.current_author = Author.all.find_by name: input
    unless session.current_author
      puts "#{input} not found in database, would you like to add them from Goodreads? (y/n)"
      choice = gets.chomp.downcase
      if choice == "y"
        new_author_url = Author.find_url_by_goodreads_search(input)
        session.current_author = Author.create_by_goodreads_url(new_author_url)
      else
        main_menu_options
      end
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
    puts "Enter 'logout' to log out of your account or 'exit' to exit MediocreReads"
    parse_author_menu_input
  end

  def parse_author_menu_input
    input = gets.chomp
    case input
    when "1" then author_highest_rated_books
    when "2" then author_most_reviewed_books
    when "3" then author_open_goodreads_page
    when "logout" then logout
    when "exit" then goodbye
    when "back"
      session.current_author = nil
      main_menu_options
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

  def main_find_user_reviewed_books
    user = session.current_user
    unless Review.find_by(user_id: user.id)
      reviews_array = Review.get_user_reviews_from_goodreads(user)
      Review.create_user_reviews_from_array(reviews_array, user)
    end
    puts "\n"
    user.reviews.each do |review|
      puts "#{review.book.title} by #{review.book.author.name}, published #{review.book.published_date}"
      puts "Your rating: #{review.rating}   Average rating: #{review.book.average_rating} from #{review.book.ratings_count} reviews"
      puts "Your review: #{review.content}\n\n"
    end
    main_menu_options
  end

  def logout
    @session = Session.new
    greet
  end

  def goodbye
    puts "Thank you for using MediocreReads, come back soon! Goodbye!"
  end
end