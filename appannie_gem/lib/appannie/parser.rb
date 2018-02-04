class Parser
	def parse_rating(response, type)

		hash = JSON.parse(response)
		ratings = hash["ratings"]
		relevant_rating = ratings.select { | entry | entry["country"] == "DE" || entry["country"].nil? }.first
		
		rating = Rating.create(country: relevant_rating["country"] || "ALL",
					  average: relevant_rating["all_ratings"]["average"],
					  count: relevant_rating["all_ratings"]["rating_count"],
					  s1: relevant_rating["all_ratings"]["star_1_count"],
					  s2: relevant_rating["all_ratings"]["star_2_count"],
					  s3: relevant_rating["all_ratings"]["star_3_count"],
					  s4: relevant_rating["all_ratings"]["star_4_count"],
					  s5: relevant_rating["all_ratings"]["star_5_count"],
					  type: type
					  )
		rating.save
		rating
	end

	def parse_rankings(response)
		hash = JSON.parse(response)
		ranks = hash["product_ranks"].first
		parsed_ranks = ranks["ranks"].map { | key, value|
			date = Date.parse(key, "%Y%d%m")
			rank = Rank.new
			rank.date = date
			rank.rank = value.to_s
			rank
		}.sort_by{ | rank | rank.date }
		return parsed_ranks
	end


	def parse_reviews(response)
		hash = JSON.parse(response)
		reviews = hash["reviews"]
		reviews
	end

	def parse_downloads(response)
		hash = JSON.parse(response)
		sales_list = hash["sales_list"]
		sales_list.map { | entry |
			download = Download.new
			date = Date.parse(entry["date"], "%Y%dm")
			download.date = date
			download.count = entry["units"]["product"]["downloads"]
			download
		}.sort_by{ | download | download.date }
	end
end