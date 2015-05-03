class Result < ActiveRecord::Base
	attr_accessible :ranking_id, :score

	belongs_to :ranking
	belongs_to :game, :through => :ranking
	belongs_to :user, :through => :ranking

	validates_presence_of :user_id, :ranking_id, :score
	
end