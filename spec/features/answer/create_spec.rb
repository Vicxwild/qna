require "rails_helper"

feature "User can create answer to question", "
  In order to information on the question
  As authenticated user
  I'd like to be able to answer questions
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe "Authenticated user" do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario "tries to answer question" do
      fill_in "Body", with: "Good answer"
      click_on "Answer"

      expect(page).to have_content "Your answer to the question successfully created."
      expect(page).to have_content question.title
      expect(page).to have_content "Good answer"
    end

    scenario "tries to answer question with errors" do
      click_on "Answer"

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Unauthenticated user tries to answer question" do
    visit question_path(question)
    fill_in "Body", with: "Bad answer"
    click_on "Answer"

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
