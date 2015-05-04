class Ranking < ActiveRecord::Base

	belongs_to	:game
	belongs_to	:user
	has_one		:result

	# Scopes

	# Validate

	validates_presence_of :user_id, :game_id, :color1, :color2, :color3, :color4


# include Colorscore
# histogram = Histogram.new('#{self.game.image.file.current_path}')

# # This image is 78.8% #7a9ab5:
# histogram.scores.first # => [0.7884625, RGB [#7a9ab5]]
# histogram.scores[i].last
# # This image is closest to pure blue:
# palette = Palette.from_hex([color1, color2, color3, color4])
# scores = palette.scores(histogram.scores, 1)
# scores.first # => [0.16493763694876, RGB [#0000ff]]


	def create_result
		# histogram = 

		user_colors ||= []
		user_colors << :color1
		user_colors << :color2
		user_colors << :color3
		user_colors << :color4

		all_rankings ||= []
		(4..20).each do |seg_num|
			array = `color_quant #{self.game.image.file.current_path} #{seg_num}`
			array.split!("\n")
			all_rankings << array if array.shift == "success"
		end

		score = all_rankings.min do |ranking|
			# gets total match score between user_colors and ranking_colors
			user_colors.inject(0) do |r, user_hex|
				# gets the distance between the current user_hex and the most similar ranking_hex
				# in which ranking_hex can only be from the top 4 most common colors
				r + ranking[0..3].min do |ranking_hex|
					colorDistance(user_hex, ranking_hex)
				end
			end
		end
		result = Result.new(:ranking_id => self.id, :score => score)
	end

	def getRGB(color)
	    red = ((color & 0xff0000) >> 16)
	    green = ((color & 0x00ff00) >> 8)
	    blue = (color & 0x0000ff)
	    return red, green, blue
	end

	def colorDistance(hex1, hex2)
	    r1, g1, b1 = getRGB(hex1)
	    r2, g2, b2 = getRGB(hex2)

	    rDist = (r1 - r2) ** 2
	    gDist = (g1 - g2) ** 2
	    bDist = (b1 - b2) ** 2

	    return (rDist + gDist + bDist) ** 0.5
	end

end
