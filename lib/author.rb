class Author < ActiveRecord::Base
  has_many :books
  has_many :reviews, through: :books
  has_many :genres, through: :books
end
