SCHEDULER.every '1h', :first_in => 0 do |job|

  def rating_stars(value)
    case value
    when 1
      "★☆☆☆☆"
    when 2
      "★★☆☆☆"
    when 3
      "★★★☆☆"
    when 4
      "★★★★☆"
    when 5
      "★★★★★"
    else
      "?"
    end
  end


  apiclient = ApiClient.new
  parser = Parser.new

  ios_app = ENV['IOS_APP_ID']
  reviews_response = apiclient.get_ios_reviews(ios_app)
  reviews =  parser.parse_reviews(reviews_response).first(10)

  rows = reviews.map { | hash | { cols: [ { value: rating_stars(hash["rating"])}, { class: 'left', value: hash["text"]} ]} }

  send_event('reviews', { rows: rows } )
end
