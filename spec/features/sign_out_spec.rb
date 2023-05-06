require "rails_helper"

feature "User can sign out", "
  In order to exit of the system
  As authenticated user
  I'd like to be able to log out
" do
  given(:user) { create(:user) }

  scenario "Authenticated user tries to log out" do
    sign_in(user)

    click_on "Log out"

    expect(page).to have_content "Signed out successfully."
  end
end
