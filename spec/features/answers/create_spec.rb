require "rails_helper"

feature "User can create answer to question", "
  In order to information on the question
  As authenticated user
  I'd like to be able to answer questions
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe "Authenticated user", js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario "tries to answer question" do
      fill_in "Body", with: "Good answer"
      click_on "Answer"

      expect(current_path).to eq question_path(question)
      within ".answers" do
        expect(page).to have_content "Good answer"
      end
    end

    scenario "tries to answer question with errors" do
      click_on "Answer"

      expect(page).to have_content "Body can't be blank"
    end

    scenario "answers with attached files" do
      fill_in "Body", with: "Good answer"

      attach_file "File", ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on "Answer"

      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end
  end

  scenario "Unauthenticated user tries to answer question" do
    visit question_path(question)
    fill_in "Body", with: "Bad answer"
    click_on "Answer"

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end

  context "multipe sessions", js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session("user") do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session("guest") do
        visit question_path(question)
      end

      Capybara.using_session("user") do
        fill_in "Body", with: "Good answer"
        click_on "Answer"

        within ".answers" do
          expect(page).to have_content "Good answer"
        end
      end

      Capybara.using_session("guest") do
        within ".answers" do
          expect(page).to have_content "Good answer"
        end
      end
    end
  end
end
