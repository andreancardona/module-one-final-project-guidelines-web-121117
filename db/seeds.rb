#@API_KEY = '8dQUUUZ8wokkPMjjn2oRxA'

author_id_array = [545, 566, 8132662, 1221698, 1214964, 6466154, 3389, 3565, 88506]


author_id_array.each do |author_id|
  #binding.pry
  author = RestClient.get("https://www.goodreads.com/author/list/#{author_id}?format=xml&key=8dQUUUZ8wokkPMjjn2oRxA")
  author_hash = Nokogiri::XML(author)
  author_name = author_hash.xpath("//name").first.text
  Author.create(name: author_name)
end
