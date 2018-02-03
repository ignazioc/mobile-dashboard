SCHEDULER.every '6h', :first_in => 3 do |job|
	
	apiclient = ApiClient.new
	ios_app = ENV['IOS_APP_ID']
	ios_category = "Overall"
	android_app = ENV['ANDROID_APP_ID']
	android_category = "OVERALL > APPLICATION"
	
	ios_rankings = apiclient.get_ios_rankings(ios_app, ios_category)
	android_rankings = apiclient.get_android_rankings(android_app, android_category)
	
	labels = ios_rankings.map { | rank | rank.date.strftime("%d/%b/%y")  }
	ios_values = ios_rankings.map { | rank | rank.rank }
	android_values = android_rankings.map { | rank | rank.rank }
	
	data = [
	{
		label: 'iOS',
		data: ios_values,
		backgroundColor: [ 'rgba(255, 100, 132, 1)' ] * labels.length,
		borderColor: [ 'rgba(255, 100, 132, 1)' ] * labels.length,
		fill: false,
		pointBorderColor: "rgb(255, 0, 0, 1)"
	}, {
		label: 'Android',
		data: android_values,
		backgroundColor: [ 'rgba(0, 162, 231,1)' ] * labels.length,
		borderColor: 'rgba(0, 162, 231,1)',
		pointBorderColor: 'rgba(255, 255, 255,1)',
		pointBorderWidth: '1',
		fill: false
	}]
	
	options = {
		scales: {
			yAxes: [ { ticks: { reverse: true } } ],
		}
	}
	puts "[Update Ovberall Ranking Chart] iOS: #{ios_values}, Android: #{android_values} "
	send_event('mobile_overall_ranks', { labels: labels, datasets: data, options: options })

end