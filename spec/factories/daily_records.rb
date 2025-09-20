require 'faker'

FactoryBot.define do
  factory :daily_record do
    mood_score { rand(-5..5) }
    memo { Faker::Quotes::Shakespeare.hamlet_quote }
    association :user
  end
end
