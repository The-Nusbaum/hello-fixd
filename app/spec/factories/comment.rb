require 'faker'

FactoryBot.define do
  factory :comment do
    user             { user = FactoryBot.build(:user); user.save; user }
    post             { post = FactoryBot.build(:post); post.save; post }
    message          { Faker::Fantasy::Tolkien.poem }
    commented_at     { Time.now }
    created_at       { Time.now }
    updated_at       { Time.now }
  end
end