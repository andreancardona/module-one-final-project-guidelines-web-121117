def get_user_data_from_goodreads_id(goodreads_id)
  user = RestClient.get("https://www.goodreads.com/user/show/#{goodreads_id}.xml")
  user_hash = Nokogiri::XML(user)
end

def find_or_create_user_from_hash(user_hash)
  