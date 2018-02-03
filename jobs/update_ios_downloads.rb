SCHEDULER.every '6h', :first_in => 2 do |job|
	
	apiclient = ApiClient.new
	ios_app = ENV['IOS_APP_ID']
	ios_downloads = apiclient.get_ios_downloads(ios_app)
	
	labels = ios_downloads.map { | download | download.date.strftime("%d/%b/%y")  }
	ios_values = ios_downloads.map { | download | download.count }
	
	data = [
	{
		label: 'iOS',
		data: ios_values,
		backgroundColor: [ 'rgba(180,140,59, 0.2)' ] * labels.length,
		borderColor: [ 'rgba(180,140,59, 1)' ] * labels.length,
		borderWidth: 1,
		fill: true,
		pointRadius: 2,
		pointBackgroundColor:"rgba(180,140,59, 1)",
		pointBorderColor: "rgba(180,140,59, 1)"
    },
    ]
    options = {
		scales: {
			yAxes: [
				{ 
					ticks: {
						fontColor: "#B4B4B4"
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
    
    puts "[FetchiOSDownloads] Downloads: #{ios_values}"
	send_event('ios_downloads', { labels: labels, datasets: data, options: options })

end