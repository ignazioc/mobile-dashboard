SCHEDULER.every '12h', :first_in => '0s' do |job|
	
  apiclient = ApiClient.new
  parser = Parser.new

  ios_app = ENV['IOS_APP_ID']
  r = apiclient.get_ios_ratings(ios_app)
  rating = parser.parse_rating(r, :ios)
  

  android_app = ENV['ANDROID_APP_ID']
  r = apiclient.get_google_ratings(android_app)
  rating = parser.parse_rating(r, :android)
end