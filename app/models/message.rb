class Message < ApplicationRecord
	after_create_commit { MessageBroadcastJob.perform_later self }
	#default_scope -> {order(created_at: :asc)}
	belongs_to :from, class_name: "User"
	belongs_to :to, class_name: "User"
	validates :from_id, presence: true
	validates :to_id, presence: true
	validates :room_id, presence: true
	validates :content, presence: true, length: {maximum: 50}

	def Message.recent_in_room(room_id)
	  where(room_id: room_id).last(500)
	end

	def Message.set_latest_three_room_ids(user)
		where(from_id: user.id).or(Message.where(to_id: user.id)).select(:room_id).distinct.order(created_at: :desc).last(3)
	end

	def Message.set_latest_room_ids(user)
		where(from_id: user.id).or(Message.where(to_id: user.id)).group(:room_id).order(created_at: :desc)
	end
end
