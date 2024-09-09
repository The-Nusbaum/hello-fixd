require 'faker'

FactoryBot.define do
  factory :post do
    user             { user = FactoryBot.build(:user); user.save; user }
    title            { Faker::Fantasy::Tolkien.location}
    body             { Faker::Fantasy::Tolkien.poem}
    posted_at        { Time.now }
    created_at       { Time.now }
    updated_at       { Time.now }
  end
end