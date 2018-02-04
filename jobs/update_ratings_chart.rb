SCHEDULER.every '6h', :first_in => 0 do |job|


entries_count = 100 
ios_ratings = Rating.all.to_a.select { | entry | entry.type == "ios" }.uniq { | entry | entry.date_string }.last(entries_count)
android_ratings = Rating.all.to_a.select { | entry | entry.type == "android" }.uniq { | entry | entry.date_string }.last(entries_count)


labels = android_ratings.map { | rating | Date.strptime(rating.date_string, "%Y%m%d").strftime("%d/%b/%y")  }

ios_values = ios_ratings.map { | rating | rating.realAVG }
android_values = android_ratings.map { | rating | rating.realAVG }


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
  }
]
options = {
		scales: {
			yAxes: [
				{ 
					ticks: {
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

puts "[Update Rating Chart] iOS: #{ios_values.count} Android: #{android_values.count}}"

send_event('linechart', { labels: labels, datasets: data, options: options })
end