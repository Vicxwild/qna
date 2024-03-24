FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end

    trait :with_files do
      files do
        [
          Rack::Test::UploadedFile.new("#{Rails.root}/spec/files/file_1.txt"),
          Rack::Test::UploadedFile.new("#{Rails.root}/spec/files/file_2.txt")
        ]
      end
    end
  end
end
