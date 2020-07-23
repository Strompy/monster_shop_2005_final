require 'rails_helper'

describe "When a visitor goes to their profile page" do
  it "shows all data and a link to edit" do
    tanya = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134")

    visit "/login"
    fill_in :email, with: "T-tar@gmail.com"
    fill_in :password, with: "Bangladesh134"
    click_on "Log In"
    expect(current_path).to eq("/profile")

    expect(page).to have_content(tanya.name)
    expect(page).to have_content(tanya.city)
    expect(page).to have_content(tanya.state)
    expect(page).to have_content(tanya.zip)
    expect(page).to have_content(tanya.address)
    expect(page).to have_content(tanya.email)
    expect(page).to_not have_content(tanya.password)

    click_on "Edit Profile"
    expect(current_path).to eq('/profile/edit')
  end
end
