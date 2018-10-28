# Preview all emails at http://localhost:3000/rails/mailers/relation_mailer
class RelationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/relation_mailer/follow
  def follow
  	follower = User.first
  	followed = User.last
    RelationMailer.follow(follower, followed)
  end

  # Preview this email at http://localhost:3000/rails/mailers/relation_mailer/unfollow
  def unfollow
  	unfollower = User.first
  	unfollowed = User.last
    RelationMailer.unfollow(unfollower, unfollowed)
  end

end
