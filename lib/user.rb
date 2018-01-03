class User < ActiveRecord::Base
  has_many :reviews
  has_many :books, through: :reviews

  def self.get_user_data_from_goodreads_id(goodreads_id)
    user = RestClient.get("https://www.goodreads.com/user/show/#{goodreads_id}.xml?key=8dQUUUZ8wokkPMjjn2oRxA")
    Nokogiri::XML(user)
  end
  
  def self.find_or_create_user_from_hash(user_hash)
    name = user_hash.css("name").first.text
    url = user_hash.css("link").first.text
    goodreads_user_id = user_hash.css("id").first.text
    user = User.find_by goodreads_user_id: goodreads_user_id
    if !user
      user = User.create(name: name, goodreads_user_url: url, goodreads_user_id: goodreads_user_id)
    end
    user
  end

end