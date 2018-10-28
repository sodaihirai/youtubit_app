require 'test_helper'

class RelationMailerTest < ActionMailer::TestCase

  def setup
    @taro = users(:Taro)
    @hanako = users(:Hanako)
  end

  test "follow" do
    mail = RelationMailer.follow(@taro, @hanako)
    assert_equal "フォロー通知", mail.subject
    assert_equal [@hanako.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
  end

  test "unfollow" do
    mail = RelationMailer.unfollow(@taro, @hanako)
    assert_equal "フォロー解除通知", mail.subject
    assert_equal [@hanako.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
  end

end
