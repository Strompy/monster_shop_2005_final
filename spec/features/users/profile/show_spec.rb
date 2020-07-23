require 'rails_helper'

describe "When a visitor goes to their profile page" do
  before :each do
    @tanya = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134")

    visit "/login"
    fill_in :email, with: "T-tar@gmail.com"
    fill_in :password, with: "Bangladesh134"
    click_on "Log In"

  end

  it "shows all data and a link to edit" do
    expect(current_path).to eq("/profile")

    expect(page).to have_content(@tanya.name)
    expect(page).to have_content(@tanya.city)
    expect(page).to have_content(@tanya.state)
    expect(page).to have_content(@tanya.zip)
    expect(page).to have_content(@tanya.address)
    expect(page).to have_content(@tanya.email)
    expect(page).to_not have_content(@tanya.password)

    click_on "Edit Profile"
    expect(current_path).to eq('/profile/edit')

    fill_in :address, with: "432 Mufasa pl"
    fill_in :city, with: "Winchester"
    fill_in :state, with: "Alabama"
    fill_in :zip, with: "90898"
    click_on "Submit"

    expect(current_path).to eq("/profile")
    expect(page).to have_content("Your data has been updated!")

    expect(page).to have_content(@tanya.name)
    expect(page).to have_content("Winchester")
    expect(page).to have_content("Alabama")
    expect(page).to have_content("90898")
    expect(page).to have_content("432 Mufasa pl")
    expect(page).to have_content(@tanya.email)
  end

  it "has a link to edit their password" do
    click_on "Edit Password"
    expect(current_path).to eq("/profile/password_edit")

    fill_in :password, with: "Secret1"
    fill_in :c_password, with: "Secret1"
    click_on "Submit"

    expect(current_path).to eq("/profile")
    expect(page).to have_content("Your password has been updated!")
  end
end
