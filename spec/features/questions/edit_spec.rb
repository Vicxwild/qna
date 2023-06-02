require "rails_helper"

feature "User can edit his question", "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:user_2) { create(:user) }

  describe "Authenticated user", js: true do
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

    scenario "edits his question with errors" do
      sign_in(user)
      visit question_path(question)

      within ".question-control" do
        click_on "Edit question"

        fill_in "Title", with: ""
        click_on "Save"

        expect(page).to have_selector "textarea"
      end

      expect(page).to have_content "Title can't be blank"
    end

    scenario "can't edit someone else question" do
      sign_in(user_2)
      visit question_path(question)

      expect(page).to_not have_link "Edit question"
    end

    context "attachments" do
      background do
        sign_in(user)
        visit question_path(question)

        within ".question-control" do
          click_on "Edit question"
          fill_in "Title", with: "edited question title"
          fill_in "Body", with: "edited question body"
          attach_file "File", ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on "Save"
        end
      end

      scenario "edits a question and can attach files" do
        expect(page).to have_link "rails_helper.rb"
        expect(page).to have_link "spec_helper.rb"
      end

      scenario "can delete attached to question file" do
        within ".question" do
          first(".attachment").click_on "Delete file"

          expect(page).to_not have_link "rails_helper.rb"
          expect(page).to have_link "spec_helper.rb"
        end
      end
    end
  end

  scenario "Unauthenticated user can't edit question" do
    visit question_path(question)

    expect(page).to_not have_link "Edit question"
  end
end
