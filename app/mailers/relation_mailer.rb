class RelationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.relation_mailer.follow.subject
  #
  def follow(follower, followed)
    @follower = follower 
    @followed = followed

    mail to: @followed.email, subject: "フォロー通知"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.relation_mailer.unfollow.subject
  #
  def unfollow(unfollower, unfollowed)
    @unfollower = unfollower
    @unfollowed = unfollowed

    mail to: @unfollowed.email, subject: "フォロー解除通知"
  end
end
