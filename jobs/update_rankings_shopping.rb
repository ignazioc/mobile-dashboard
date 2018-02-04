SCHEDULER.every '6h', :first_in => 4 do |job|
	
	apiclient = ApiClient.new
	ios_app = ENV['IOS_APP_ID']
	ios_category = ENV['IOS_PRIMARY_CATEGORY']
	android_app = ENV['ANDROID_APP_ID']
	android_category = ENV['ANDROID_PRIMARY_CATEGORY']
	
	ios_rankings = apiclient.get_ios_rankings(ios_app, ios_category)
	android_rankings = apiclient.get_android_rankings(android_app, android_category)
	
	labels = ios_rankings.map { | rank | rank.date.strftime("%d/%b/%y")  }
	ios_values = ios_rankings.map { | rank | rank.rank.to_i }
	android_values = android_rankings.map { | rank | rank.rank.to_i }

	ios_latest_ranking = ios_values.last
	android_latest_ranking = android_values.last
	
	data = [
	{
		label: 'iOS',
		data: ios_values,
		backgroundColor: [ 'rgba(180,140,59, 0.2)' ] * labels.length,
		borderColor: [ 'rgba(180,140,59, 1)' ] * labels.length,
		borderWidth: 1,
		fill: false,
		pointRadius: 2,
		pointBackgroundColor:"rgba(180,140,59, 1)",
		pointBorderColor: "rgba(180,140,59, 1)"
	}, {
		label: 'Android',
		data: android_values,
		backgroundColor: [ 'rgba(90, 158, 86, 0.2)' ] * labels.length,
		borderColor: [ 'rgba(90, 158, 86, 1)' ] * labels.length,
		borderWidth: 1,
		fill: false,
		pointRadius: 2,
		pointBackgroundColor:"rgba(90, 158, 86, 1)",
		pointBorderColor: "rgba(90, 158, 86, 1)"
	}]
	
	options = {
		scales: {
			yAxes: [
				{ 
					ticks: {
						reverse: true,
						stepSize: 1,
						fontColor: "#B4B4B4",
	                    
					} 
				} ],
			xAxes: [
				{ 
					ticks: {
						fontColor: "#B4B4B4"
					} 
				} ],

		}
	}
	puts "[Update Shopping Ranking Chart] iOS: #{ios_values}, Android: #{android_values} "

	
	send_event('ios_ranking', { current: ios_latest_ranking }) unless  ios_latest_ranking.nil?
	send_event('android_ranking', { current: android_latest_ranking }) unless  android_latest_ranking.nil?
	
	send_event('mobile_commerce_ranks', { labels: labels, datasets: data, options: options })

end