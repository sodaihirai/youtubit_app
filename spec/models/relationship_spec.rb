require 'rails_helper'

RSpec.describe Relationship, type: :model do

	before do
		@relationship = FactoryBot.create(:relationship)
	end

	it "is valid with follower and  followed" do
		expect(@relationship).to be_valid
	end

	it "is invalid without follower_id" do
		@relationship.update_attribute(:follower_id, nil)
		@relationship.valid?
		expect(@relationship.errors[:follower_id]).to include("can't be blank")
	end

	it "is invalid without followed_id" do
		@relationship.update_attribute(:followed_id, nil)
		@relationship.valid?
		expect(@relationship.errors[:followed_id]).to include("can't be blank")
	end
end
