require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user  = users(:Taro)
  	@other = users(:Hanako)
  	@rel   = relationships(:one)
  end

  test "create should redirect when not logged in" do
  	post relationships_path, params: { id: @other.id }
  	assert_redirected_to login_url
  end

  test "destroy should redirect when not logged in" do
  	delete relationship_path(@rel)
  	assert_redirected_to login_url
  end

  test "create work perfectly" do
    log_in_as @other
    assert_difference '@other.active_relationships.count', 1 do
      post relationships_path, params: { followed_id: @user.id }  
    end
    assert_redirected_to @user
  end

  test "create work perfectly with ajax" do
    log_in_as @other
    assert_difference '@other.active_relationships.count', 1 do
      post relationships_path, params: { followed_id: @user.id }, xhr: true  
    end
  end

  test "destroy work perfectly" do
    log_in_as @user
    assert_difference '@user.active_relationships.count', -1 do
      delete relationship_path(@rel)
    end
    assert_redirected_to @other
  end

  test "destroy work perfectly with ajax" do
    log_in_as @user
    assert_difference '@user.active_relationships.count', -1 do
      delete relationship_path(@rel), xhr: true
    end
  end

end
