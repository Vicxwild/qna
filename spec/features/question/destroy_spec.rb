require "rails_helper"

feature "User can delete own question", "
  In order to remove some information
  As an authenticated user
  I'd like to be able to delete own question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe "Authenticated user" do
    background do
      sign_in(user)

      question_path(question)
    end

    scenario "tries to delete own question" do
      click_on "Delete question"

      expect(page).to have_content "Your question successfully deleted."
    end

    scenario "tries to delete someone else`s question"
  end
  scenario "Unauthenticated user tries to delete question"
end
