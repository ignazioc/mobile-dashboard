SCHEDULER.every '6h', :first_in => 0 do |job|

	apiclient = ApiClient.new
	parser = Parser.new

	ios_app = ENV['IOS_APP_ID']
	ios_category = ENV['IOS_PRIMARY_CATEGORY']

	ranking_response = apiclient.get_ios_rankings(ios_app, ios_category)
	ranking = parser.parse_ranking(ranking_response)
	send_event('ios_ranking', { current: ranking })


	android_app = ENV['ANDROID_APP_ID']
	android_category = ENV['ANDROID_PRIMARY_CATEGORY']
	
	ranking_response = apiclient.get_android_rankings(android_app, android_category)
	ranking = parser.parse_ranking(ranking_response)
	send_event('android_ranking', { current: ranking })	
end