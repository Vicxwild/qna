require "rails_helper"

feature "User can edit his question", "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe "Authenticated user" do
    scenario "edits his question" do
      sign_in(user)
      visit question_path(question)

      within ".question-control" do
        click_on "Edit question"

        fill_in "Title", with: "edited question title"
        fill_in "Body", with: "edited question body"
        click_on "Save"

        expect(page).to_not have_selector "textarea"
      end

      expect(page).to_not have_content question.body
      expect(page).to have_content "edited question title"
      expect(page).to have_content "edited question body"
    end

    scenario "edits his question with errors"
    scenario "can't edit someone else question"
  end

  scenario "Unauthenticated user can't edit question" do
    visit question_path(question)

    expect(page).to_not have_link "Edit question"
  end
end
