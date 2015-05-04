class Result < ActiveRecord::Base

	belongs_to :ranking
	delegate :game, to: :ranking

	validates_presence_of :ranking_id, :score

	def self.get_result(game_id, user_id)
		Ranking.where("game_id = :game AND user_id = :user", { game: game_id, user: user_id }).first
	end

	def get_user(user_id)
		User.find(self.ranking.user_id)
	end

    def other_result(user_id)
      self.ranking.game.rankings.each do |ranking|
        if ranking.user_id != user_id
          return ranking.result
        end
      end
      return nil
    end
	
end