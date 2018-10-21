module UsersHelper

	def gravatar_for(user, size: 80)
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		image_tag(gravatar_url, alt: user.name, class: "gravatar")
	end

	def follow?(user)
		!current_user.active_relationships.find_by(followed_id: user.id).nil?
	end

	def any_follow?
		!User.where.not(follower_count: 0).group(:follower_count).max(3).first.nil?
	end
end
