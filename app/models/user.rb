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
	has_secure_password
	has_many :microposts, dependent: :destroy

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
		self.email = self.email.downcase
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

	def password_reset_expired?
		if self.reset_sent_at < 2.hours.ago
		　　flash[:warning] = "パスワード変更リンクが期限切れです"
			redirect_to new_password_reset_path
		end
	end

end
