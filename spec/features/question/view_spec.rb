require "rails_helper"

feature "User can view the list of questions", "
  In order to get full information
  As an any user
  I'd like to be able to view the list of all questions
" do
  given!(:questions) { create_list(:question, 3) }

  scenario "User tries to view the list of all questions" do
    visit questions_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
    expect(page).to have_content questions[2].title
  end
end
