FactoryBot.define do
  factory :user, aliases: [:follower, :followed] do
  	name { "sample" }
  	sequence(:email) { |n| "example#{n}@gmail.com"}
  	password_digest { User.digest("password") }
  end
end
