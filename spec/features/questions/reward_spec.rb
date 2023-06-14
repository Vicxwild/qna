require "rails_helper"

feature "User can add award to his question", "
  In order to encourage peole for exact answers
  As a question's author
  I'd like to be able to add reward
" do
  given(:user) { create(:user) }
  given(:reward_image) { "#{Rails.root}/spec/files/reward.png" }

  describe "Authenticated user", js: true do
    background do
      sign_in(user)
      visit new_question_path

      fill_in "Title", with: "Test question"
      fill_in "Body", with: "text text text"
    end

    scenario "adds reward to question" do
      fill_in "Reward title", with: "Great job!"
      attach_file "Image", reward_image

      click_on "Ask"

      expect(page).to have_content "Your question successfully created."
    end

    scenario "adds invalid image to the award" do
      fill_in "Reward title", with: "Great job!"
      click_on "Ask"
      expect(page).to have_content "You must add an image file."
    end

    scenario "adds invalid image to the award" do
      attach_file "Image", reward_image
      click_on "Ask"
      expect(page).to have_content "Reward title can't be blank"
    end
  end
end
