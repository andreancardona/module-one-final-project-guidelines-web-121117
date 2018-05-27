class Genre < ActiveRecord::Base
  has_many :books
  has_many :authors, through: :books

  def self.unwanted_shelves
    ["audiobooks", "novel", "novels", "1001-books", "nonfiction", "paulo-coelho", "to-read", "currently-reading", "sci-fi", "scifi", "favorites", "owned", "sf", "kindle", "audiobook", "default"]
  end

end
