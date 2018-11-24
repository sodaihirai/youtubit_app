require 'rails_helper'

RSpec.describe Micropost, type: :model do
	before do
		@micropost = FactoryBot.create(:micropost)
	end

	it "is valid with attributes" do
		expect(@micropost).to be_valid
		puts @micropost.user.inspect
	end
end
