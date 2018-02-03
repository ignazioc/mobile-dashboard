SCHEDULER.every '12h', :first_in => '0s' do |job|
	
  apiclient = ApiClient.new
  parser = Parser.new

  ios_app = ENV['IOS_APP_ID']
  r = apiclient.get_ios_rating(ios_app)
  puts  "[FetchRating] Ratings: #{r}"
  

  android_app = ENV['ANDROID_APP_ID']
  r = apiclient.get_android_rating(android_app)
  puts  "[FetchRating] Rating: #{r}"
end