require "rails_helper"

feature "User can delete own question", "
  In order to remove some information
  As an authenticated user
  I'd like to be able to delete own question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  given(:user_2) { create(:user) }
  given(:question_2) { create(:question, author: user_2) }

  describe "Authenticated user" do
    background { sign_in(user) }

    scenario "can delete own question" do
      visit question_path(question)
      click_on "Delete question"

      expect(page).to have_content "Your question successfully deleted."
    end

    scenario "tries to delete someone else`s question" do
      visit question_path(question_2)

      expect(page).to_not have_content "Delete question"
    end
  end

  scenario "Unauthenticated user tries to delete question" do
    visit question_path(question)

    expect(page).to_not have_content "Delete question"
  end
end
