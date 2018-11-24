FactoryBot.define do
  factory :micropost do
    content { "amazing" }
    video_title { "exmaple" }
    video_type { "exmaple" }
    channel_title { "exmaple" }
    video_url { "exmaple.com" }
    video_thumbnail { "exmaple.com" }
    channel_url { "exmaple.com" }
    association :user
  end
end
