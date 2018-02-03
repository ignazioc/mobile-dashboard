SCHEDULER.every '6h', :first_in => 5 do |job|
	
	apiclient = ApiClient.new
	ios_app = ENV['IOS_APP_ID']
	ios_downloads = apiclient.get_ios_downloads(ios_app)
	
	labels = ios_downloads.map { | download | download.date.strftime("%d/%b/%y")  }
	ios_values = ios_downloads.map { | download | download.count }
	
	data = [
	{
		label: 'iOS',
		data: ios_values,
		backgroundColor: [ 'rgba(255, 100, 132, 1)' ] * labels.length,
		borderColor: [ 'rgba(255, 100, 132, 1)' ] * labels.length,
		fill: false,
		pointBorderColor: "rgb(255, 0, 0, 1)"
    },
    ]
    options = {}
    
    puts "[FetchiOSDownloads] Downloads: #{ios_values}"
	send_event('ios_downloads', { labels: labels, datasets: data, options: options })

end