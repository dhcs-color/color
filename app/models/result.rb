class Result < ActiveRecord::Base

	belongs_to :ranking
	delegate :game, to: :ranking

	validates_presence_of :ranking_id, :score
	
end