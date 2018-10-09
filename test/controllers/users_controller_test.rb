require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:Taro)
    @other = users(:Hanako)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should get index" do
    log_in_as(@user)
    get users_path
    assert_response :success
  end

  test "should get edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_response :success
  end

  test "should edit redirect when not logged in" do
    get edit_user_path(@user)
    assert_redirected_to login_url
  end

  test "should update redirect when not logged in" do
    patch user_path(@user)
    assert_redirected_to login_url
  end

  test "should index redirect when not logged in" do
    get users_path(@user)
    assert_redirected_to login_url
  end

  test "should edit redirect when wrong user" do
    log_in_as(@user)
    get edit_user_path(@other)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should update redirect when wrong user" do
    log_in_as(@user)
    patch user_path(@other)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should unsubscribe redirect when not logged in" do
    get unsubscribe_user_path(@user)
    assert_redirected_to login_url
  end

  test "should destroy redirect when not logged in" do
    delete user_path(@user)
    assert_redirected_to login_url
  end

  test "should unsubscribe redirect when wrong user" do
    log_in_as(@user)
    get unsubscribe_user_path(@other)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should destroy redirect when not wrong user" do
    log_in_as(@user)
    assert_no_difference 'User.count' do
      delete user_path(@other)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end

end
