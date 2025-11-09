FactoryBot.define do
  factory :action_item do
    association :user
    association :action_tag
    name { "行動項目" }
    behavior_type { "dynamic" }
    enabled_from { 0 }
  end
end
