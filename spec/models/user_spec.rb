require 'rails_helper'

RSpec.describe User, type: :model do
	before do
		@user = FactoryBot.create(:user)
	end

	it "is valid with name, email and password" do
		expect(@user).to be_valid
	end

	it "is invalid without name" do
		@user.update_attribute(:name, nil)
		@user.valid?
		expect(@user.errors[:name]).to include("can't be blank")
	end

	it "is invalid with name more than 50" do
		name = "a" *51
		@user.update_attribute(:name, name)
		@user.valid?
		expect(@user.errors[:name]).to include("is too long (maximum is 50 characters)")
	end

	it "is invalid without email" do
		@user.update_attribute(:email, nil)
		@user.valid?
		expect(@user.errors[:email]).to include("can't be blank")
	end

	it "is invalid with email more than 255" do
		email = "a" *244 + "@example.com"
		@user.update_attribute(:email, email)
		@user.valid?
		expect(@user.errors[:email]).to include("is too long (maximum is 255 characters)")
	end

	it "is valid with valid format email" do
		valid_emails = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
        valid_emails.each do |email|
        	@user.update_attribute(:email, email)
        	expect(@user).to be_valid
        end
	end

	it "is invalid with invalid format email" do
		invalid_emails = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
        invalid_emails.each do |email|
        	@user.update_attribute(:email, email)
        	@user.valid?
        	expect(@user.errors[:email]).to include("is invalid")
        end
	end

	it "is invalid with some email" do
		other = User.new(
			name: "sample",
			email: @user.email,
			password: "hiraisoudai")
		other.valid?
		expect(other.errors[:email]).to include "has already been taken"
	end

	it "'s email in database should be downcase" do
		email = "ExaMple.Com@Exmaple.CoM"
		@user.update_attribute(:email, email)
		expect(@user.reload.email).to eq email.downcase
	end

	it "is invalid without password" do
		@user.update_attribute(:password, nil)
		@user.valid?
		expect(@user.errors[:password]).to include("can't be blank")
	end

	it "is invalid with password less than 6" do
		password = "a" *5
		@user.update_attribute(:password, password)
		@user.valid?
		expect(@user.errors[:password]).to include "is too short (minimum is 6 characters)"
		puts @user.inspect
	end
end
