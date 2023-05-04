require "rails_helper"

feature "User can sign out", "
  In order to exit of the system
  As authenticated user
  I'd like to be able to log out
" do
  given(:user) { User.create!(email: "user@test.com", password: "12345678") }

  background { visit new_user_session_path }

  scenario "Authenticated user tries to log out" do
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Log in"
    click_on "Log out"

    expect(page).to have_content "Signed out successfully."
  end
end
