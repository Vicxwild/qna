require "rails_helper"

feature "User can comment on the question", "
  In order to offer a advise for the question
  As an authenticated user
  I'd like to be able to comment on the question
" do
  given!(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question) }

  describe "Authenticated user", js: true do
    context "multipe sessions" do
      scenario "question comment appears on another user's page" do
        Capybara.using_session("user") do
          sign_in(user)
          visit question_path(question)

          within ".question" do
            expect(page).to_not have_selector(".comment")
          end
        end

        # Capybara.using_session("another_user") do
        #   sign_in(another_user)
        #   visit question_path(question)

        #   within ".question" do
        #     expect(page).to_not have_selector(".comment")
        #   end
        # end

        # Capybara.using_session("guest") do
        #   visit question_path(question)

        #   within ".question" do
        #     expect(page).to_not have_selector(".comment")
        #     expect(page).to_not have_content "Question comment"
        #   end
        # end

        Capybara.using_session("user") do
          within ".question" do
            fill_in "Type your comment", with: "Question comment"
            click_on "Comment"
            wait_for_ajax
          end

          within ".question .comments" do
            expect(page).to have_content "Comment by #{user.email}"
            expect(page).to have_content "Question comment"
          end
        end

        # Capybara.using_session("another_user") do
        #   within ".question .comments" do
        #     expect(page).to have_content "Comment by #{user.email}"
        #     expect(page).to have_content "Question comment"
        #   end
        # end

        # Capybara.using_session("guest") do
        #   within ".question .comments" do
        #     expect(page).to have_content "Comment by #{user.email}"
        #     expect(page).to have_content "Question comment"
        #   end
        # end
      end
    end
  end

  describe "Unauthenticated user" do
    background { visit question_path(question) }

    scenario "can't see a form for add comment" do
      within ".question" do
        expect(page).to_not have_selector(".add_comment")
      end
    end
  end
end
