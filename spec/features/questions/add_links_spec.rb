require "rails_helper"

feature "User can add links to question", "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { "https://gist.github.com/Vicxwild/6a1458756d13d3a658ee5e0331e7bc14" }
  given(:google_url) { "https://www.google.com" }

  describe "Authenticated user", js: true do
    background do
      sign_in(user)
      visit new_question_path

      fill_in "Title", with: "Test question"
      fill_in "Body", with: "text text text"

      click_on "add link"

      fill_in "Link name", with: "My gist"
      fill_in "Url", with: gist_url
    end

    scenario "adds link when asks question" do
      click_on "Ask"

      expect(page).to have_link "My gist", href: gist_url
    end

    scenario "adds two links when asks question" do
      click_on "add link"

      within all(".nested-fields").last do
        fill_in "Link name", with: "Google"
        fill_in "Url", with: google_url
      end

      click_on "Ask"

      expect(page).to have_link "My gist", href: gist_url
      expect(page).to have_link "Google", href: google_url
    end

    scenario "adds gist link when asks question" do
      click_on "Ask"

      within_frame find("iframe.gist-content") do
        expect(page).to have_content "gistfile1.txt"
        expect(page).to have_content "Hello world!"
      end
    end

    scenario "adds link when edits question" do
      click_on "Ask"

      click_on "Edit"

      within ".question-control" do
        click_on "add link"
      end

      within all(".nested-fields").last do
        fill_in "Link name", with: "Github"
        fill_in "Url", with: "https://github.com/"
      end

      click_on "Save"

      expect(page).to have_link "My gist", href: gist_url
      expect(page).to have_link "Github", href: "https://github.com/"
    end
  end
end
