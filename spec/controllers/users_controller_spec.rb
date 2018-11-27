require 'rails_helper'

RSpec.describe UsersController, type: :controller do
	describe "#new" do
		before do
			@user = FactoryBot.create(:user)
		end

		it "responds successfully" do
			get :new
			expect(response).to be_successful
		end
	end

	describe "#index" do
		let(:user) { FactoryBot.create(:user) }
	
		context "as a login user" do
			it "reponds successfully" do
				log_in user
				get :index
				expect(response).to be_successful
			end
		end

		context "as a guest" do
			it "returns a 302 response" do
				get :index
				expect(response).to have_http_status "302"
			end

			it "redirects to the login page" do
				get :index
				expect(response).to redirect_to login_url
			end
		end
	end

	describe "#create" do
		user_params = FactoryBot.attributes_for(:user)

		it "creates a user" do
			expect {
				post :create, params: { user: user_params }
			}.to change(User, :count).by(1)
		end
	end

	describe "#index_search" do

		context "as a guest" do
			it "returns a 302 response" do
				post :index_search
				expect(response).to have_http_status "302"
			end

			it "redirects to the login page" do
				post :index_search
				expect(response).to redirect_to login_url
			end
		end 
	end

	describe "#show" do
		
	end


end
