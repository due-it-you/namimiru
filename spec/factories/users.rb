FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "たかし#{n}号" }
    sequence(:email) { |n| "user_#{n}@gmail.com" }
    password {'G554557h'}
    password_confirmation {'G554557h'}
  end
end
