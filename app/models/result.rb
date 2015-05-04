class Result < ActiveRecord::Base

	belongs_to :ranking
	delegate :game, to: :ranking

	validates_presence_of :ranking_id, :score

  def other_result(user_id)
    self.ranking.game.rankings.each do |ranking|
      if ranking.user_id != user_id
        return ranking.result
      end
    end
    return nil
  end
	
end