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

  describe "Authenticated user" do
    scenario "selects the best answer for the first time", js: true do
      sign_in(user)
      visit question_path(question)

      within "#answer_#{answer_2.id}" do
        click_on "The Best Answer"
      end

      within ".best-answer" do
        expect(page).to have_content "The best answer to the question:"
        expect(page).to have_content answer_2.body
        expect(page).to_not have_link "The Best Answer"
      end
    end

    scenario "selects the best answer for the second time", js: true do
      sign_in(user)
      visit question_path(question)

      within "#answer_#{answer_2.id}" do
        click_on "The Best Answer"
      end

      within "#answer_#{answer_1.id}" do
        click_on "The Best Answer"
      end

      within ".best-answer" do
        expect(page).to have_content "The best answer to the question:"
        expect(page).to have_content answer_1.body
        expect(page).to_not have_link "The Best Answer"
      end
    end

    scenario "can't select best answer for other user question" do
      sign_in(create(:user))
      visit question_path(question)

      expect(page).to_not have_link "The Best Answer"
    end
  end

  describe "Unauthenticated user" do
    scenario "can't select best answer" do
      visit question_path(question)

      expect(page).to_not have_link "The Best Answer"
    end
  end
end
