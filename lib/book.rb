class Book < ActiveRecord::Base
  belongs_to :authors
  belongs_to :genres
  has_many :reviews
end
