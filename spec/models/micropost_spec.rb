require 'rails_helper'

RSpec.describe Micropost, type: :model do
	before do
		@micropost = FactoryBot.create(:micropost)
	end

	it "is valid with attributes" do
		expect(@micropost).to be_valid
	end

	it "is invalid without content" do
		@micropost.update_attribute(:content, nil)
		@micropost.valid?
		expect(@micropost.errors[:content]).to include "can't be blank" 
	end

	it "is invalid without video_title" do
		@micropost.update_attribute(:video_title, nil)
		@micropost.valid?
		expect(@micropost.errors[:video_title]).to include "can't be blank" 
	end

	it "is invalid without video_url" do
		@micropost.update_attribute(:video_url, nil)
		@micropost.valid?
		expect(@micropost.errors[:video_url]).to include "can't be blank" 
	end

	it "is invalid without video_thumbnail" do
		@micropost.update_attribute(:video_thumbnail, nil)
		@micropost.valid?
		expect(@micropost.errors[:video_thumbnail]).to include "can't be blank" 
	end

	it "is invalid without video_type" do
		@micropost.update_attribute(:video_type, nil)
		@micropost.valid?
		expect(@micropost.errors[:video_type]).to include "can't be blank" 
	end

	it "is invalid without user_id" do
		@micropost.update_attribute(:user_id, nil)
		@micropost.valid?
		expect(@micropost.errors[:user_id]).to include "can't be blank" 
	end

	it "is invalid without channel_url" do
		@micropost.update_attribute(:channel_url, nil)
		@micropost.valid?
		expect(@micropost.errors[:channel_url]).to include "can't be blank" 
	end

	it "is invalid without channel_title" do
		@micropost.update_attribute(:channel_title, nil)
		@micropost.valid?
		expect(@micropost.errors[:channel_title]).to include "can't be blank" 
	end

	describe "seach micropost for a term by saerch_by_content" do
		before do
			@micropost1 = FactoryBot.create(:micropost)
			@micropost2 = FactoryBot.create(:micropost, :sea_america)
			@micropost3 = FactoryBot.create(:micropost, :sea_surprised)
		end

		context "parameter is content" do

			context "when a match is found" do
				it "returns micropost that match the search term" do
					expect(Micropost.search_by_parameter("content", "amazing")).to include(@micropost1, @micropost2)
				end

				it "does not micropost that does not match the search term" do
					expect(Micropost.search_by_parameter("content", "amazing")).to_not include(@micropost3)
				end
			end

			context "when no match is found" do
				it "returns empty" do
					expect(Micropost.search_by_parameter("content", "nice")).to be_empty
				end
			end
		end

		context "parameter is video_title" do

			context "when a match is found" do
				it "returns micropost that match the search term" do
					expect(Micropost.search_by_parameter("video_title", "sea")).to include(@micropost2, @micropost3)
				end

				it "does not micropost that does not match the search term" do
					expect(Micropost.search_by_parameter("video_title", "sea")).to_not include(@micropost1)
				end
			end

			context "when no match is found" do
				it "returns empty" do
					expect(Micropost.search_by_parameter("video_title", "danger")).to be_empty
				end
			end
		end

		context "parameter is channel_title" do

			context "when a match is found" do
				it "returns micropost that match the search term" do
					expect(Micropost.search_by_parameter("channel_title", "123")).to include(@micropost1, @micropost3)
				end

				it "does not micropost that does not match the search term" do
					expect(Micropost.search_by_parameter("channel_title", "123")).to_not include(@micropost2)
				end
			end

			context "when no match is found" do
				it "returns empty" do
					expect(Micropost.search_by_parameter("channel_title", "finebaby")).to be_empty
				end
			end
		end

	end

	describe "search micropost for a term by search_by_parameter_sort_by_video_type" do
		before do 
			@micropost1 = FactoryBot.create(:micropost)
			@micropost2 = FactoryBot.create(:micropost, :sea_america_sports)
			@micropost3 = FactoryBot.create(:micropost, :sea_surprised_party)
		end

		context "parameter is content" do
			it "returns micropost that match the search term and sort by video_type" do
				expect(Micropost.search_by_parameter_sort_by_video_type("content", "amazing", "example")).to include(@micropost1)
			end

			it "does not returns micropost that does not match ther sort" do
				expect(Micropost.search_by_parameter_sort_by_video_type("content", "amazing", "example")).to_not include(@micropost2)
			end
		end

		context "parameter is video_title" do
			it "returns micropost that match the search term and sort by video_type" do
				expect(Micropost.search_by_parameter_sort_by_video_type("video_title", "sea", "sports")).to include(@micropost2)
			end

			it "does not returns micropost that does not match ther sort" do
				expect(Micropost.search_by_parameter_sort_by_video_type("video_title", "sea", "sports")).to_not include(@micropost3)
			end
		end

		context "parameter is channel_title" do
			it "returns micropost that match the search term and sort by video_type" do
				expect(Micropost.search_by_parameter_sort_by_video_type("channel_title", "123", "party")).to include(@micropost3)
			end

			it "does not returns micropost that does not match ther sort" do
				expect(Micropost.search_by_parameter_sort_by_video_type("channel_title", "123", "party")).to_not include(@micropost1)
			end
		end
	end

	it "returns contributor of micropost" do
		user = FactoryBot.create(:user)
		micropost = FactoryBot.create(:micropost, user: user)
		expect(micropost.contributor).to eq user
	end
end
