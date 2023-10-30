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

    scenario "can revote for question" do
      within ".question" do
        find(".dislike").click
        find(".revote").click
        find(".like").click

        votes_sum_element = find(".votes-sum")
        expect(votes_sum_element).to have_text("1")
      end

      expect(question.reload.votes_sum).to eq(1)
    end

    scenario "can't see revote button if didn't vote" do
      within ".question" do
        expect(page).to_not have_selector(".revote")
      end
    end

    scenario "can't see revote button after revoting" do
      within ".question" do
        find(".dislike").click
        find(".revote").click

        expect(page).to_not have_selector(".revote")
      end
    end
  end

  describe "Unauthenticated user", js: true do
    scenario "can't see the revote button" do
      visit question_path(question)
      within ".question" do
        expect(page).to_not have_selector(".revote")
      end
    end
  end
end
