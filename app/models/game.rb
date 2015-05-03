class Game < ActiveRecord::Base
	# duan told me to remove it!
	# attr_accessible :game_id, :from_user_id, :to_user_id, :is_accepted

	# Relationships
	belongs_to :from_user, class_name: "User", foreign_key: "from_user_id"
	belongs_to :to_user, class_name: "User", foreign_key: "to_user_id"
	has_one :image
	has_many :rankings
	has_many :results, :through => :rankings 

	# Validations
	validates_presence_of :game_id, :from_user_id, :to_user_id, :is_accepted

	# Scopes
	scope :accepted, -> {
		where(is_accepted: true)
	}
	scope :pending, -> {
		where(is_accepted: false)
	}
	scope :by_date, -> {
		order('created_at DESC')
	}
	scope :users_games, lambda {|user_id| where("from_user_id = :user OR to_user_id = :user",
																							{ user: user_id })}

	# Methods

	def self.waiting_on_user(user_id)
		user_games = Game.joins(:rankings).users_games(user_id).accepted
		user_games.reject do |game|
			game.rankings.any? {|r| r.user_id == user_id}
		end
	end

	def self.waiting_on_friend(user_id)
		user_games = Game.joins(:rankings).users_games(user_id).accepted
		user_games.reject do |game|
			game.rankings.any? {|r| r.user_id != user_id}
		end
	end

	def self.completed(user_id)
		user_games = Game.joins(:rankings).users_games(user_id).accepted
		user_games.reject{ |game| game.rankings.size < 2 }
	end

end
