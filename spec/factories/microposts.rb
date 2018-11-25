FactoryBot.define do
  factory :micropost do
    content { "amazing" }
    video_title { "example" }
    video_type { "example" }
    channel_title { "123" }
    video_url { "example.com" }
    video_thumbnail { "example.com" }
    channel_url { "example.com" }
    association :user

    trait :sea_america do
        video_title { "sea" }
        channel_title { "america" }
    end

    trait :sea_surprised do
        video_title { "sea" }
        content { "surprised" }
    end

    trait :sea_america_sports do
        video_title { "sea" }
        channel_title { "america" }
        video_type { "sports" }
    end

    trait :sea_surprised_party do
        video_title { "sea" }
        content { "surprised" }
        video_type { "party" }
    end

  end
end
