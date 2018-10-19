require 'test_helper'

class LikeTest < ActiveSupport::TestCase

  def setup
  	@like = Like.new(user_id: users(:Taro).id, micropost_id: microposts(:good).id)
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
end
