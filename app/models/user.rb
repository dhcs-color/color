class User < ActiveRecord::Base
	# attr_accessible :name, :image

	has_many :games
	has_many :rankings, :through => :games
	has_many :results, :through => :rankings
	
	scope :alphabetical, -> {
		order(name: :asc)
	}

	def self.omniauth(auth)
	  where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
	    user.provider = auth.provider
	    user.uid = auth.uid
	    user.name = auth.info.name
	    user.image = auth.info.image
	    user.token = auth.credentials.token
	    user.expires_at = Time.at(auth.credentials.expires_at)
	    user.save!
	  end
	end
end
