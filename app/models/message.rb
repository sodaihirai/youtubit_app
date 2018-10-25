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

	#def Message.set_latest_room_ids(user)
	#	where("from_id = :user_id OR to_id = :user_id", user_id: user.id).group(:room_id).order(id: :desc)
	#end

	def Message.set_latest_room_ids(user)
		set = Message.select('MAX(id) AS max_id').group(:room_id).map { |message| message.max_id }
		where('id IN (?)', set).order(id: :desc)
	end

	def Message.set_latest_room_ids_for_search(chat_users_ids, user)
		where("(from_id IN (:chat_users_ids) AND to_id = :user_id) OR (to_id IN (:chat_users_ids) AND from_id = :user_id)", chat_users_ids: chat_users_ids, user_id: user.id).group(:room_id).order(created_at: :desc)
	end
end
