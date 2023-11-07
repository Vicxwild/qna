FactoryBot.define do
  factory :comment do
    commentable { nil }
    association :author
    body { "Comment text" }
  end
end
