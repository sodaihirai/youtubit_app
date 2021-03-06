class User < ApplicationRecord
	attr_accessor :remember_token, :activation_token, :reset_token
	before_save :downcase_email
	before_create :activate
	validates :name,  presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 }, 
	                                  format: { with: VALID_EMAIL_REGEX },
	                                  uniqueness:  { case_sensitive: false }
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
	validates :follower_count, presence: true
	has_secure_password

	has_many :microposts, dependent: :destroy

	has_many :active_relationships, class_name: 'Relationship', foreign_key: "follower_id", dependent: :destroy
	has_many :passive_relationships, class_name: 'Relationship', foreign_key: "followed_id", dependent: :destroy
	has_many :following, through: :active_relationships,  source: :followed
	has_many :followers, through: :passive_relationships, source: :follower

	has_many :likes, dependent: :destroy

	scope :search_by_user_name, -> (keyword) {
    where("users.name LIKE :keyword", keyword: "%#{sanitize_sql_like(keyword)}%") if keyword.present? }
	#これがあるとmicropostでuserを求められる
	#has_many :microposts, through: :likes, source: :micropost
	has_many :from_messages, class_name: "Message", foreign_key: "from_id", dependent: :destroy
	has_many :to_messages, class_name: "Message", foreign_key: "to_id", dependent: :destroy

	def User.digest(string)
	    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
	                                                  BCrypt::Engine.cost
	    BCrypt::Password.create(string, cost: cost)
	end

	def User.new_token
		SecureRandom.urlsafe_base64
	end

	def remember
		self.remember_token = User.new_token
		self.update_attribute(:remember_digest, User.digest(remember_token))
	end

	def activate
		self.activation_token = User.new_token
		self.activation_digest = User.digest(activation_token)
		#self.update_attribute(:activation_digest, User.digest(activation_token))
	end

	def create_reset_digest
		self.reset_token = User.new_token
		self.update_attributes(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
	end

	def downcase_email
		self.email = self.email.downcase unless self.email.nil?
	end

	def authenticated?(action, token)
		#digest = send("#{action}_digest")
		#return false if self.digest.nil?
		#BCrypt::Password.new(self.digest).is_password?(token)
		digest = self.send("#{action}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	def forget
		self.update_attribute(:remember_digest, nil)
	end

	def follow(user)
		self.following << user
	end

	def unfollow(relationship_id)
		self.active_relationships.find(relationship_id).destroy
	end

	def following_count
		active_relationships.count
	end

	def follower_count
		passive_relationships.count
	end

	def feed
	    following_ids = "SELECT followed_id FROM relationships
	                     WHERE follower_id = :user_id"
	    Micropost.where("user_id IN (#{following_ids})
	                     OR user_id = :user_id", user_id: id)
  	end	

	def password_reset_expired?
		self.reset_sent_at < 2.hours.ago
	end

	def User.set_third_counts_of_follower_count
		where.not(follower_count: 0).map{ |user| user.follower_count}.uniq.max(3)
	end

	def User.set_third_follower_counts_users
		third_counts_of_follower_count = User.set_third_counts_of_follower_count.last
		where('follower_count >= ?', third_counts_of_follower_count).order(follower_count: :desc)
	end

	def send_message(other_user, room_id, content)
		from_messages.create!(to_id: other_user.id, room_id: room_id, content: content)
	end

	


end
