class Action < ApplicationRecord
	validates :action_user_id, presence: true
	validates :type_id, presence: true
	validates :action_type, presence: true
end