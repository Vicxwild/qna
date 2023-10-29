require "rails_helper"

feature "User can change the decision to vote for a question", "
  In order to change the decision
  As an authenticated user
  I'd like to be able to revote for question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe "Authenticated user", js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "can revote for question (like)" do
      within ".question" do
        find(".dislike").click
        find(".revote").click
        find(".like").click

        votes_sum_element = find(".votes-sum")
        expect(votes_sum_element).to have_text("1")
      end

      expect(question.reload.votes_sum).to eq(1)
    end
  end
end
