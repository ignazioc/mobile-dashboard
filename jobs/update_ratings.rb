SCHEDULER.every '6h', :first_in => 10 do |job|

	ios_latest_rating = Rating.find_by_type(:ios).last
	android_latest_rating = Rating.find_by_type(:android).last

	ios_previouos_rating = Rating.find_by_type(:ios).to_a.reverse.drop_while { | entry |
		Date.parse(entry.created_at) - Date.today == 0
	}.first

	if ios_previouos_rating.nil?
		ios_previouos_rating = ios_latest_rating
	end

	android_previouos_rating = Rating.find_by_type(:android).to_a.reverse.drop_while { | entry | 
		Date.parse(entry.created_at) - Date.today == 0
	}.first

	if android_previouos_rating.nil? 
		android_previouos_rating = android_latest_rating
	end

	send_event('ios_rating', { current: ios_latest_rating.realAVG.round(2), last: ios_previouos_rating.realAVG.round(2) })
	send_event('android_rating', { current: android_latest_rating.realAVG.round(2), last: android_previouos_rating.realAVG.round(2) })
end