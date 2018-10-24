require 'test_helper'

class LikeTest < ActiveSupport::TestCase

  def setup
    @user = users(:Taro)
    @micropost = microposts(:good)
  	@like = Like.new(user_id: @user.id, micropost_id: @micropost.id)
  end  

  test "should be valid" do
  	assert @like.valid?
  end

  test "user_id should be presence" do
  	@like.user_id = nil
  	assert_not @like.valid?
  end

  test "micropost_id should be presence" do
  	@like.micropost_id = nil
  	assert_not @like.valid?
  end

  test "likes should depends on user" do
    assert_difference '@user.likes.count', -@user.likes.count do
      @user.destroy
    end
  end

  test "likes should depends on micropost" do
    assert_difference '@micropost.likes.count', -@micropost.likes.count do
      @micropost.destroy
    end
  end
end
