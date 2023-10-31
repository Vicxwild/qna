FactoryBot.define do
  factory :answer do
    association :question
    association :author, factory: :user
    body { "MyAnswerText" }

    trait :invalid do
      body { nil }
    end
  end
end
