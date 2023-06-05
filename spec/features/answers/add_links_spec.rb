require "rails_helper"

feature "User can add links to answer", "
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:gist_url) { "https://gist.github.com/Vicxwild/6a1458756d13d3a658ee5e0331e7bc14" }

  scenario "User adds link when asks question", js: true do
    sign_in(user)
    visit question_path(question)

    within ".question-answer" do
      fill_in "Body", with: "Good answer"

      fill_in "Link name", with: "My gist"
      fill_in "Url", with: gist_url

      click_on "Answer"
    end

    within ".answers" do
      expect(page).to have_link "My gist", href: gist_url
    end
  end
end
