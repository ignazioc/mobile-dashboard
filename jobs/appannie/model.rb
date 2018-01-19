
class Rating
	include CsvRecord::Document

	attr_accessor :country, :average, :count, :s1, :s2, :s3, :s4, :s5, :type, :date_string

	def to_s
		"[#{self.type}] #{self.country}: #{self.realAVG}"
	end

	def realAVG
		multiplier = [1,2,3,4,5]
		ratings = [s1.to_i, s2.to_i, s3.to_i, s4.to_i, s5.to_i]
		sum = [multiplier, ratings].transpose.map { | x | x.reduce(:*) }.reduce(:+)
		return (sum.to_f / count.to_i)
	end

	after_create do
		self.date_string = self.created_at.strftime("%Y%m%d")
	end
end


