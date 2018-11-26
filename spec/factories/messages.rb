FactoryBot.define do
  factory :message do
  	association :from
  	association :to
  	room_id "a"
  	content "how are you"
  end
end
