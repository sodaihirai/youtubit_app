require 'rails_helper'

RSpec.describe Message, type: :model do
	before do
		@message = FactoryBot.create(:message)
	end

	it "is valid with from_id, to_id, room_id and content" do
		expect(@message).to be_valid
	end

	it "is invalid without from_id" do
		@message.update_attribute(:from_id, nil)
		@message.valid?
		expect(@message.errors[:from_id]).to include("can't be blank")
	end

	it "is invalid without to_id" do
		@message.update_attribute(:to_id, nil)
		@message.valid?
		expect(@message.errors[:to_id]).to include("can't be blank")
	end

	it "is invalid without room_id" do
		@message.update_attribute(:room_id, nil)
		@message.valid?
		expect(@message.errors[:room_id]).to include("can't be blank")
	end

	it "is invalid without content" do
		@message.update_attribute(:content, nil)
		@message.valid?
		expect(@message.errors[:content]).to include("can't be blank")
	end

	it "depends on from" do
		from = FactoryBot.create(:user)
		message = FactoryBot.create(:message, from: from)
		expect {
			from.destroy
		}.to change(Message, :count).by(-1)
	end

	it "depends on to" do
		to = FactoryBot.create(:user)
		message = FactoryBot.create(:message, to: to)
		expect {
			to.destroy
		}.to change(Message, :count).by(-1)
	end
end
