FactoryBot.define do
  factory :answer do
    body { "MyAnswerText" }
    question

    trait :invalid do
      body { nil }
    end
  end
end
