require 'rails_helper'

RSpec.describe Action, type: :model do
	before do
		@action = FactoryBot.create(:action)
	end

	it "is valid with action_user_id and content" do
		expect(@action).to be_valid
	end

	it "is invalid without action_user_id" do
		@action.update_attribute(:action_user_id, nil)
		@action.valid?
		expect(@action.errors[:action_user_id]).to include("can't be blank")
	end

	it "is invalid without content" do
		@action.update_attribute(:content, nil)
		@action.valid?
		expect(@action.errors[:content]).to include("can't be blank")
	end

	it "is invalid without type_id" do
		@action.update_attribute(:type_id, nil)
		@action.valid?
		expect(@action.errors[:type_id]).to include("can't be blank")
	end

	it "is invalid without action_type" do
		@action.update_attribute(:action_type, nil)
		@action.valid?
		expect(@action.errors[:action_type]).to include("can't be blank")
	end
end
