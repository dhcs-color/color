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
	validates_presence_of :from_user_id, :to_user_id

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
	scope :recieved_games, lambda {|user_id| where("to_user_id = :user", { user: user_id })}
	scope :users_games, lambda {|user_id| where("from_user_id = :user OR to_user_id = :user", { user: user_id })}

	# Methods

	def other_user(user_id)
		user_id == self.from_user ? User.find(self.to_user) : User.find(self.from_user)
	end

	def waiting_on_user(user_id)
		self.rankings.each do |ranking|
			return false if ranking.user_id == user_id
		end
	end

	def self.needs_image
		user_games = Game.users_games(user_id).accepted
		arr = user_games.reject do |game|
			game.image.nil? == false
		end
		Game.where(id: arr.map(&:id))
	end

	def self.waiting_on_user(user_id)
		needs_image = Game.needs_image(user_id)
		user_games = Game.users_games(user_id).accepted
		arr = user_games.reject do |game|
			game.rankings.any? {|r| r.user_id == user_id}
		end
		arr.reject! {|game| needs_image.include?(game)}
		Game.where(id: arr.map(&:id))
	end

	def self.waiting_on_friend(user_id)
		waiting_user = Game.waiting_on_user(user_id)
		user_games = Game.users_games(user_id)
		arr = user_games.reject do |game|
			game.rankings.any? {|r| r.user_id != user_id}
		end
		arr.reject! {|game| waiting_user.include?(game)}
		Game.where(id: arr.map(&:id))
	end

	def self.completed(user_id)
		user_games = Game.users_games(user_id).accepted
		arr = user_games.reject{ |game| game.rankings.size < 2 }
		Game.where(id: arr.map(&:id))
	end

end
