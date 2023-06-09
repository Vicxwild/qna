require "rails_helper"

feature "User can register", "
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to register
" do
  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario "Unregistered user tries to register" do
    fill_in "Email", with: "user@test.com"
    fill_in "Password", with: "12345678"
    fill_in "Password confirmation", with: "12345678"
    click_on "Sign up"

    expect(page).to have_content "Welcome! You have signed up successfully."
  end

  scenario "Registered user tries to register" do
    fill_in "Email", with: user.email
    fill_in "Password", with: "112345678"
    fill_in "Password confirmation", with: "112345678"
    click_on "Sign up"

    expect(page).to have_content "Email has already been taken"
  end

  scenario "Unregistered user tries to register with dissimilar password confirmation" do
    fill_in "Email", with: "invalid@email.com"
    fill_in "Password", with: "12345678"
    fill_in "Password confirmation", with: "123456789"
    click_on "Sign up"

    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end
