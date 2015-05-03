class Game < ActiveRecord::Base
	attr_accessible :game_id, :from_user_id, :to_user_id, :image_path, :is_accepted

	# Relationships
	belongs_to :from_user, class_name: "User", foreign_key: "from_user_id"
	belongs_to :to_user, class_name: "User", foreign_key: "to_user_id"
	has_many :rankings
	has_many :results, :through => :rankings 

	# Validations
	validates_presence_of :game_id, :from_user_id, :to_user_id, :image_path, :is_accepted

	# Scopes
	scope :acccepted, where(is_accepted: true)
	scope :pending, where(is_accepted: false)
	scope :by_date, order('created_at DESC')
	scope :users_games, lambda {|user_id| where("from_user_id = :user OR to_user_id = :user",
																							{ user_id: user_id })}

	# Methods

	def self.waiting_on(user_id)
		user_games = Game.joins(:rankings).users_games(user_id).accepted
		user_games.reject do |game|
			game.rankings.inject(false) {|r, e| r || e.user_id == user_id}
		end
	end

	def self.completed(user_id)
		user_games = Game.joins(:rankings).users_games(user_id).accepted
		user_games.reject{ |game| game.rankings.size < 2 }
		end
	end
end
