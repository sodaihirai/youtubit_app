class Micropost < ApplicationRecord
	belongs_to :user
	validates :content, 		presence: true, length: { maximum: 140 }
	validates :video_title, 	presence: true
	validates :video_url, 		presence: true
	validates :video_thumbnail, presence: true
	validates :video_type, 		presence: true
	validates :user_id, 		presence: true
	validates :channel_title, 	presence: true
	default_scope -> { order(created_at: :desc) }
	
	def contributor
		User.find(self.user_id)
	end
end
