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
    backgroundColor: [ 'rgba(255, 100, 132, 1)' ] * labels.length,
    borderColor: [ 'rgba(255, 100, 132, 1)' ] * labels.length,
    fill: false
  }, {
    label: 'Android',
    data: android_values,
    backgroundColor: [ 'rgba(0, 162, 231,1)' ] * labels.length,
    borderColor: [ 'rgba(0, 162, 231,1)' ] * labels.length,
    fill: false
  }
]
options = { }

send_event('linechart', { labels: labels, datasets: data, options: options })
end