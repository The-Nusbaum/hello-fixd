require 'faker'

FactoryBot.define do
  factory :user do
    name             { Faker::Fantasy::Tolkien.character}
    email            { Faker::Internet.email(domain: 'example.com')}
    github_username  { nil }
    password         { "secure_pass" }
    registered_at    { Time.now }
    created_at       { Time.now }
    updated_at       { Time.now }
  end
end