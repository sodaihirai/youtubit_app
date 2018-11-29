FactoryBot.define do
  factory :action do
    action_user_id { 1 }
    type_id { 2 }
    action_type { "follow" }

    trait :like do
    	action_type { "like" }
    end
  end
end
