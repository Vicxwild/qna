require "rails_helper"

feature "User can view question with answers", "
  In order to get full information from a community
  As an any type of user
  I'd loke to be able to view answers along with question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 3, question: question, author: user) }

  scenario "User tries to watch question with answers" do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    expect(page).to have_content answers[0].body
    expect(page).to have_content answers[1].body
    expect(page).to have_content answers[2].body
  end
end
