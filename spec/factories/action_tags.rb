FactoryBot.define do
  factory :action_tag do
    association :user
    name { "タグ" }
  end
end
