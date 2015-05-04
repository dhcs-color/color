class Result < ActiveRecord::Base

	belongs_to :ranking
	belongs_to :game, :through => :ranking
	belongs_to :user, :through => :ranking

	validates_presence_of :user_id, :ranking_id, :score
	
end