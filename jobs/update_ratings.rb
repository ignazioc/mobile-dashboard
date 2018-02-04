SCHEDULER.every '1h', :first_in => 5 do |job|

	ios = Rating.all.to_a.select { | entry | entry.type == "ios" }
	unless ios.kind_of?(Array)
		ios = [ ios ]
	end

	android = Rating.all.to_a.select { | entry | entry.type == "android" }
	unless android.kind_of?(Array)
		android = [ android ]
	end

	ios_latest_rating = ios.last
	android_latest_rating = android.last

	puts "[UpdateRating] Latest rating: #{ios_latest_rating} from total of: #{ios.count}"
	puts "[UpdateRating] Latest rating: #{android_latest_rating} from total of: #{android.count}"


	ios_previouos_rating = ios.reverse.drop_while { | entry |
		Date.parse(entry.created_at) - Date.today == 0
	}.first

	if ios_previouos_rating.nil?
		ios_previouos_rating = ios_latest_rating
	end

	android_previouos_rating = android.reverse.drop_while { | entry | 
		Date.parse(entry.created_at) - Date.today == 0
	}.first

	if android_previouos_rating.nil? 
		android_previouos_rating = android_latest_rating
	end

	send_event('ios_rating', { current: ios_latest_rating.realAVG.round(2) })
	send_event('android_rating', { current: android_latest_rating.realAVG.round(2)})
end