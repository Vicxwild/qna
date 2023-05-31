require "rails_helper"

feature "User can edit his answer", "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given(:user_2) { create(:user) }

  describe "Authenticated user", js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "edits his answer" do
      click_on "Edit"

      within ".answers" do
        fill_in "Your answer", with: "edited answer"
        click_on "Save"

        expect(page).to_not have_content answer.body
        expect(page).to have_content "edited answer"
        expect(page).to_not have_selector "textarea"
      end
    end

    scenario "edits his answer with errors" do
      click_on "Edit"

      within ".answers" do
        fill_in "Your answer", with: ""
        click_on "Save"

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_content answer.body
        expect(page).to have_selector "textarea"
      end
    end
  end

  scenario "Authenticated user can't edit someone else answer" do
    sign_in(user_2)
    visit question_path(question)

    expect(page).to_not have_link "Edit"
  end

  scenario "Unauthenticated user can't edit answer" do
    visit question_path(question)

    expect(page).to_not have_link "Edit"
  end
end
