require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
  	@user = User.new(name: "exampele", email: "example@gmail.com", password: "password", password_confirmation: "password")
  end

  test "should be valid" do
  	assert @user.valid?
  end

  test "name should be presence" do
  	@user.name = nil
  	assert_not @user.valid?
  end

  test "email should be presence" do
  	@user.email = nil
  	assert_not @user.valid?
  end

  test "name should be less than 51" do
  	@user.name = "a" * 51
  	assert_not @user.valid?
  end

  test "email should be less than 256" do
  	@user.email = "a" * 246 + "@gmail.com"
  	assert_not @user.valid?
  end

  test "email with correct format should be valid" do
  	valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
    	@user.email = valid_address
    	assert @user.valid?, "#{valid_address} sholud be valid"
    end
  end

  test "email with invalid format should not be valid" do
  	invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
    	@user.email = invalid_address
    	assert_not @user.valid?, "#{invalid_address} should not be valid"
    end
  end

  test "email should be unique" do
  	other = @user.dup
  	other.email = @user.email.upcase
  	@user.save
  	assert_not other.valid?
  end

  test "email in the database should be downcase" do
  	mixed_email = "eXamPle@Gmail.COM"
  	@user.email = mixed_email
  	@user.save
  	assert_equal mixed_email.downcase, @user.reload.email
  end

  test "password and password_confirmation sholud be present" do
  	@user.password = @user.password_confirmation = nil
  	assert_not @user.valid?
  end

  test "password and password_confirmation should be more than 5" do
  	@user.password = @user.password_confirmation = "a" * 5
  	assert_not @user.valid?
  end

  test "password should be presence when edit" do
  	@user.save
  	@user.password = @user.password_confirmation = " " * 6
  	assert_not @user.valid?
  end
end
