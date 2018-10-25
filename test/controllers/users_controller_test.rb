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

  test "should followers redirect when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end

  test "should following redirect when not logged in " do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "index_search redirect when not logged in" do
    post index_search_users_path, params: { q: "content" }
    assert_redirected_to login_url
  end

  test "chat redirect when not logged in" do
    get chat_user_path(@other)
    assert_redirected_to login_url
  end

  test "chat redirect when the template is yourself" do
    log_in_as(@user)
    get chat_user_path(@user)
    assert_redirected_to root_url
  end

  test "chat work when the template is others" do
    log_in_as(@user)
    get chat_user_path(@other)
    assert_template 'users/chat'
  end

  test "chat_index redirect when not logged in" do
    get chat_index_user_path(@user)
    assert_redirected_to login_url
  end

  test "chat_index redirect when not correct_user" do
    log_in_as(@user)
    get chat_index_user_path(@other)
    assert_redirected_to root_url
  end

  test "chat_index work when correct_user" do
    log_in_as(@user)
    get chat_index_user_path(@user)
    assert_template 'users/chat_index'
  end

  test "chat_search redirect when not logged in" do
    post chat_search_user_path(@user), params: { q: "example" }
    assert_redirected_to login_url
  end

  test "chat_search redirect when no correct_user" do
    log_in_as(@user)
    post chat_search_user_path(@other), params: { q: "example"}
    assert_redirected_to root_url
  end

  test "chat_search work when correct_user" do
    log_in_as(@user)
    post chat_search_user_path(@user), params: { q: "example" }
    assert_template 'users/chat_index'
  end

  test "chat_search work when correct_user with ajax" do
    log_in_as(@user)
    post chat_search_user_path(@user), params: { q: "example"}, xhr: true
    assert_response :success
  end

end
