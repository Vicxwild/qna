require "rails_helper"

feature "User can select the best answer to question", "
  In order to mark important information
  As authenticated user
  I'd like to be able to select the best answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer_1) { create(:answer, question: question, author: user) }
  given!(:answer_2) { create(:answer, question: question, author: user) }
  given!(:answer_3) { create(:answer, question: question, author: user) }

  describe "Authenticated user", js: true do
    scenario "selects the best answer for the first time" do
      sign_in(user)
      visit question_path(question)

      within "#answer_#{answer_2.id}" do
        click_on "The Best Answer"

        expect(page).to have_content answer_2.body
        expect(page).to_not have_link "The Best Answer"
      end
    end

    scenario "selects the best answer for the second time"

    scenario "can't select best answer for other user question"
  end

  describe "Unauthenticated user", js: true do
    scenario "can't select best answer" do
      visit question_path(question)

      expect(page).to_not have_link "The Best Answer"
    end
  end
end
