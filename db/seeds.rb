User.create(name: "Example User",
			email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)

25.times do
  content = Faker::Lorem.sentence(5)
  users.each do |user|
    user.microposts.create!(content: content,
                            video_title: "Navy Seal Commander explains why wake up at 4am",
                            video_url: "https://www.youtube.com/channel/UCtinbF-Q-fVthA0qrFQTgXQ",
                            video_thumbnail: "https://i.ytimg.com/vi/C-Cvl3_CH2A/default.jpg",
                            video_type: "モチベーション",
                            channel_title: "CaseyNeistat",
                            channel_url: "https://www.youtube.com/channel/UCtinbF-Q-fVthA0qrFQTgXQ"
                            )
  end
end

25.times do
  content = Faker::Lorem.sentence(5)
  users.each do |user|
    user.microposts.create!(content: content,
                            video_title: "【ショートハイライト】日本×ウルグアイ　キリンチャレンジカップ2018サッカー日本代表×ウルグアイ代表",
                            video_url: " https://www.youtube.com/watch?v=2kC9vgZHi_M",
                            video_thumbnail: "https://i.ytimg.com/vi/2kC9vgZHi_M/default.jpg",
                            video_type: "スポーツ",
                            channel_title: "パーキー#1",
                            channel_url: "https://www.youtube.com/channel/UCR7eWC0w2g0nKC8dLWsc0ng"
                            )
  end
end