FactoryBot.define do
  factory :user, aliases: [:follower, :followed] do
  	name { "taro tanaka" }
  	sequence(:email) { |n| "example#{n}@gmail.com"}
  	password_digest { User.digest("password") }

  	trait :taro_yoshida do
  		name { "taro yoshida"}
  	end

  	trait :hanako_ikeda do
  		name { "hanako ikeda" }
  	end
  end
end
