require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  
  def setup
  	@user = users(:Taro)
  	@other = users(:Hanako)
  	@relationship = Relationship.new(follower_id: @user.id, followed_id: @other.id)
  end

  test "should be valid" do
  	assert @relationship.valid?
  end

  test "follower_id should be present" do
  	@relationship.follower_id = nil
  	assert_not @relationship.valid?	
  end

  test "followed_id should be present" do
  	@relationship.followed_id = nil
  	assert_not @relationship.valid?
  end

end
