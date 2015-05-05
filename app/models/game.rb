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
	scope :sent_games, lambda {|user_id| where("from_user_id = :user", { user: user_id })}
	scope :users_games, lambda {|user_id| where("from_user_id = :user OR to_user_id = :user", { user: user_id })}

	# Methods

	def other_user(user_id)
		if user_id == self.from_user.id
			User.find(self.to_user.id)
		else
			User.find(self.from_user.id)
		end
	end

	def waiting_on_user(user_id)
		if self.rankings.any?{ |ranking| ranking.user_id == user_id }
			return false
		else
			return true
		end
	end

	def self.needs_image(user_id)
		invites = Game.recieved_games(user_id).pending
		user_games = Game.users_games(user_id)
		arr = user_games.reject do |game|
			!game.image.nil?
		end
		arr.reject! {|game| invites.include?(game)}
		Game.where(id: arr.map(&:id))
	end

	def self.waiting_on_user(user_id)
		invites = Game.recieved_games(user_id).pending
		needs_image = Game.needs_image(user_id)
		completed = Game.completed(user_id)
		user_games = Game.users_games(user_id).accepted
		arr = user_games.reject do |game|
			game.rankings.any? {|r| r.user_id == user_id}
		end
		arr.reject! {|game| needs_image.include?(game)}
		arr.reject! {|game| completed.include?(game)}
		arr.reject! {|game| invites.include?(game)}
		Game.where(id: arr.map(&:id))
	end

	def self.waiting_on_friend(user_id)
		invites = Game.recieved_games(user_id).pending
		needs_image = Game.needs_image(user_id)
		completed = Game.completed(user_id)
		waiting_user = Game.waiting_on_user(user_id)
		user_games = Game.users_games(user_id)
		arr = user_games.reject do |game|
			game.rankings.any? {|r| r.user_id != user_id}
		end
		arr.reject! {|game| invites.include?(game)}
		arr.reject! {|game| needs_image.include?(game)}
		arr.reject! {|game| waiting_user.include?(game)}
		arr.reject! {|game| completed.include?(game)}
		Game.where(id: arr.map(&:id))
	end

	def self.completed(user_id)
		user_games = Game.users_games(user_id).accepted
		arr = user_games.reject{ |game| game.waiting_on_user(user_id) || game.waiting_on_user(game.other_user(user_id)) }
		Game.where(id: arr.map(&:id))
	end

end
