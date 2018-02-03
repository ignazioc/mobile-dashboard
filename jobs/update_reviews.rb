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
  reviews = apiclient.get_ios_reviews(ios_app).first(10).sort_by { | review | review["rating"].to_i }.reverse

  rows = reviews.map { | hash | { cols: [ { value: rating_stars(hash["rating"])}, { class: 'left', value: hash["text"]} ]} }

  send_event('reviews', { rows: rows } )
end
