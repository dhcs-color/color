class Ranking < ActiveRecord::Base
	attr_accessible :game_id, :user_id, :user_colors

	belongs_to	:game
	belongs_to	:user
	has_one		:result

	# Scopes

	# Validate

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

	# for testing

	color1 = 0xcabb6c
	color2 = 0xcbbc5f

	puts colorDistance(color1, color2).to_s()
	
end
