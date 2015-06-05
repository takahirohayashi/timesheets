namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = Member.create!(name: "Example User",
                           email: "example@railstutorial.jp",
                           password: "foobar",
                           password_confirmation: "foobar",
                           administrator: true)

    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.jp"
      password  = "password"
      Member.create!(name: name,
                     email: email,
                     password: password,
                     password_confirmation: password)
    end
  end
end