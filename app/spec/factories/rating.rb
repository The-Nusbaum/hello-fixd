FactoryBot.define do
  factory :rating do
    user          { user = FactoryBot.build(:user); user.save; user }
    rater         { user = FactoryBot.build(:user); user.save; user }
    rating        { rand 1..5 }
    rated_at      { Time.now }
    created_at    { Time.now }
    updated_at    { Time.now }
  end
end