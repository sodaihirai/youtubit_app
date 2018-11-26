require 'rails_helper'

RSpec.describe Like, type: :model do
	before do
		@like = FactoryBot.create(:like)
	end

	it "is valid with user_id and micropost_id" do
		expect(@like).to be_valid
	end

	it "is invalid without user_id" do
		@like.update_attribute(:user_id, nil)
		@like.valid?
		expect(@like.errors[:user_id]).to include("can't be blank")
	end

	it "is invalid without micropost_id" do
		@like.update_attribute(:micropost_id, nil)
		@like.valid?
		expect(@like.errors[:micropost_id]).to include("can't be blank")
	end

	it "depends on user" do
		user = FactoryBot.create(:user)
		like = FactoryBot.create(:like, user: user)
		expect {
			user.destroy
		}.to change(Like, :count).by(-1)
	end

	it "depends on micropost" do
		micropost = FactoryBot.create(:micropost)
		like = FactoryBot.create(:like, micropost: micropost)
		expect {
			micropost.destroy
		}.to change(Like, :count).by(-1)
	end
end
