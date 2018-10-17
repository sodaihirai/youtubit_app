class StaticPagesController < ApplicationController

	def home
		if logged_in?
			@feeds = current_user.feed
		end
	end

	def about
	end

	def contact
	end

	def help
	end
	
end
