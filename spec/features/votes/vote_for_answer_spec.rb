require "rails_helper"

feature "User can vote for answer", "
  In order to change the rating of a answer
  As an authenticated user
  I'd like to be able to vote for answer
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:own_answer) { create(:answer, question: question, author: user) }

  describe "Authenticated user", js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "can vote for answer (like)" do
      within "#answer_#{answer.id}" do
        find(".like").click

        votes_sum_element = find(".votes-sum")
        expect(votes_sum_element).to have_text("1")
      end

      expect(answer.reload.votes_sum).to eq(1)
    end

    scenario "can vote for answer (dislike)" do
      within "#answer_#{answer.id}" do
        find(".dislike").click

        votes_sum_element = find(".votes-sum")
        expect(votes_sum_element).to have_text("-1")
      end

      expect(answer.reload.votes_sum).to eq(-1)
    end

    scenario "can't vote for own answer" do
      within "#answer_#{own_answer.id}" do
        find(".dislike").click
      end

      expect(page).to have_content "You don't have enough authority"
    end

    scenario "can revote for answer" do
      within "#answer_#{answer.id}" do
        find(".dislike").click
        find(".revote").click
        find(".like").click

        votes_sum_element = find(".votes-sum")
        expect(votes_sum_element).to have_text("1")
      end

      expect(answer.reload.votes_sum).to eq(1)
    end

    scenario "can't see revote button if didn't vote" do
      within "#answer_#{answer.id}" do
        expect(page).to_not have_selector(".revote")
      end
    end

    scenario "can't see revote button after revoting" do
      within "#answer_#{answer.id}" do
        find(".dislike").click
        find(".revote").click

        expect(page).to_not have_selector(".revote")
      end
    end
  end

  describe "Unauthenticated user", js: true do
    background do
      visit question_path(question)
    end

    scenario "can't see the like button" do
      within "#answer_#{answer.id}" do
        expect(page).to_not have_selector(".like")
      end
    end

    scenario "can't see the dislike button" do
      within "#answer_#{answer.id}" do
        expect(page).to_not have_selector(".dislike")
      end
    end

    scenario "can't see the revote button" do
      within "#answer_#{answer.id}" do
        expect(page).to_not have_selector(".revote")
      end
    end
  end
end
