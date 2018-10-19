class StaticPagesController < ApplicationController

	def home
		@feeds = current_user.feed if logged_in?
	end

	def about
	end

	def contact
	end

	def help
	end
	
end
