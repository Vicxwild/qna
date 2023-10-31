FactoryBot.define do
  factory :vote do
    association :user
    value { 1 }
  end
end
