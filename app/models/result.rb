class Result < ActiveRecord::Base

	belongs_to :ranking
	delegate :game, to: :ranking
	delegate :user, to: :ranking

	validates_presence_of :ranking_id, :score

	def self.get_result(game_id, user_id)
		Ranking.where("game_id = :game AND user_id = :user", { game: game_id, user: user_id }).first
	end

    def other_result
      own_user = self.ranking.user
      self.ranking.game.rankings.each do |ranking|
        if ranking.user_id != own_user
          return ranking.result
        end
      end
      return nil
    end
	
end