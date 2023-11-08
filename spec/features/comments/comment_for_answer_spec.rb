require "rails_helper"

feature "User can comment on the answer", "
  In order to offer a advise for the answer
  As an authenticated user
  I'd like to be able to comment on the answer
" do
  given!(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:answer) { create(:answer) }
  given(:question) { answer.question }

  describe "Authenticated user", js: true do
    context "multipe sessions" do
      scenario "answer comment appears on another user's page" do
        Capybara.using_session("user") do
          sign_in(user)
          visit question_path(question)

          within ".answers" do
            expect(page).to_not have_selector(".comment")
          end
        end

        Capybara.using_session("another_user") do
          sign_in(another_user)
          visit question_path(question)

          within ".answers" do
            expect(page).to_not have_selector(".comment")
          end
        end

        Capybara.using_session("guest") do
          visit question_path(question)

          within ".answers" do
            expect(page).to_not have_selector(".comment")
          end
        end

        Capybara.using_session("user") do
          within ".answers" do
            fill_in "Type your comment", with: "Answer comment"
            click_on "Comment"
          end

          within ".answer .comments" do
            expect(page).to have_content "Comment by #{user.email}"
            expect(page).to have_content "Answer comment"
          end
        end

        Capybara.using_session("another_user") do
          within ".answer .comments" do
            expect(page).to have_content "Comment by #{user.email}"
            expect(page).to have_content "Answer comment"
          end
        end

        Capybara.using_session("guest") do
          within ".answer .comments" do
            expect(page).to have_content "Comment by #{user.email}"
            expect(page).to have_content "Answer comment"
          end
        end
      end
    end
  end

  describe "Unauthenticated user" do
    background { visit question_path(question) }

    scenario "can't see a form for add comment" do
      within ".answers" do
        expect(page).to_not have_selector(".add_comment")
      end
    end
  end
end
