class Result < ActiveRecord::Base

	belongs_to :ranking
	delegate :game, to: :ranking
	delegate :user, to: :ranking

	validates_presence_of :user_id, :ranking_id, :score
	
end