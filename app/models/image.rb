class Image < ActiveRecord::Base
	
	mount_uploader :file, FileUploader # Tells rails to use this uploader for this model.

	belongs_to :game

	validates :game_id, presence: true
end
