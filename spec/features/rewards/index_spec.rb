require "rails_helper"

feature "User can view the list of rewards", "
  In order to viewing achievements
  As an authenticated user
  I'd like to be able to view the list of all my rewards
" do
  given(:user) { create(:user) }
  given(:question_1) { create(:question, author: user) }
  given(:question_2) { create(:question, author: user) }
  given(:answer_1) { create(:answer, question: question_1, author: user) }
  given(:answer_2) { create(:answer, question: question_2, author: user) }

  given(:link_to_image) { "#{Rails.root}/spec/files/reward.png" }

  background do
    create(:reward,
      title: "Reward 1",
      image: Rack::Test::UploadedFile.new(link_to_image),
      answer: answer_1,
      question: question_1)

    create(:reward,
      title: "Reward 2",
      image: Rack::Test::UploadedFile.new(link_to_image),
      answer: answer_2,
      question: question_2)

    sign_in(user)
    visit rewards_path
  end

  scenario "Authenticated user tries to view the list of all his rewards" do
    user.rewards.each do |reward|
      expect(page).to have_content reward.title
      expect(page).to have_css("img[src*='#{reward.image.filename}']")
      expect(page).to have_content reward.question.title
    end
  end
end
