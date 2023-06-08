require "rails_helper"

feature "User can add links to answer", "
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:gist_url) { "https://gist.github.com/Vicxwild/6a1458756d13d3a658ee5e0331e7bc14" }
  given(:google_url) { "https://www.google.com" }

  describe "Authenticated user", js: true do
    background do
      sign_in(user)
      visit question_path(question)

      within ".question-answer" do
        fill_in "Body", with: "Good answer"

        click_on "add link"

        fill_in "Link name", with: "My gist"
        fill_in "Url", with: gist_url
      end
    end

    scenario "User adds link when answers question" do
      click_on "Answer"

      within ".answers" do
        expect(page).to have_link "My gist", href: gist_url
      end
    end

    scenario "User adds two links when answers question" do
      within ".question-answer" do
        click_on "add link"

        within all(".nested-fields").last do
          fill_in "Link name", with: "Google"
          fill_in "Url", with: google_url
        end
      end

      click_on "Answer"

      expect(page).to have_link "My gist", href: gist_url
      expect(page).to have_link "Google", href: google_url
    end

    scenario "adds gist link when answers question" do
      click_on "Answer"

      within_frame do
        expect(page).to have_content "gistfile1.txt"
        expect(page).to have_content "Hello world!"
      end
    end
  end
end
