FactoryBot.define do
  factory :link do
    sequence(:name) { |n| "MyURL_#{n}" }
    sequence(:url) { |n| "https://www.my_url_#{n}.com" }
  end
end
