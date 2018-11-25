FactoryBot.define do
  factory :relationship, aliases:[:active_relationship, :passive_relationship] do
    association :follower
    association :followed
  end
end
