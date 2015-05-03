class Result < ActiveRecord::Base
<<<<<<< HEAD
	# attr_accessible :ranking_id, :score
=======
>>>>>>> 53046d8937d54ed256851843b7411d86dbafdcdc

	belongs_to :ranking
	belongs_to :game, :through => :ranking
	belongs_to :user, :through => :ranking

	validates_presence_of :user_id, :ranking_id, :score
	
end