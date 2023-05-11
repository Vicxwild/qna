require "rails_helper"

feature "User can delete own answer", "
  In order to remove some own answers
  As authenticated user
  I'd like to be able to delete own question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  given(:user_2) { create(:user) }

  describe "Authenticated user" do
    scenario "can delete own answer" do
      sign_in(user)

      visit question_path(question)
      click_on "Delete answer"

      expect(page).to have_content "Your answer successfully deleted."
      expect(page).to have_content question.title
      expect(page).to_not have_content answer.body
    end

    scenario "tries to delete someone else answer" do
      sign_in(user_2)

      visit question_path(question)

      expect(page).to_not have_content "Delete answer"
    end
  end

  scenario "Unauthenticated user tries to delete answer" do
    visit question_path(question)

    expect(page).to_not have_content "Delete answer"
  end
end
