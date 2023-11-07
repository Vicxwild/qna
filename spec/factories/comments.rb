FactoryBot.define do
  factory :comment do
    commentable { nil }
    association :author, factory: :user
    body { "Comment text" }
  end
end
