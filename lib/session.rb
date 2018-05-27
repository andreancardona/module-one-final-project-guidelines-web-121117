class Session
  attr_accessor :current_user, :current_book, :current_author

  def initialize
    @current_user = nil
    @current_book = nil
    @current_author = nil
    @last_menu = nil
  end
end
