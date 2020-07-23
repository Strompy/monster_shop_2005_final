require 'rails_helper'

describe "When a visitor goes to their profile page" do
  it "shows all data and a link to edit" do
    tanya = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134")

    visit "/login"
    fill_in :email, with: "T-tar@gmail.com"
    fill_in :password, with: "Bangladesh134"
    click_on "Log In"
    expect(current_path).to eq("/profile")

    click_on "Edit Profile"

    expect(find_field(:name).value).to eq('Tanya')
    expect(find_field(:address).value).to eq('145 Uvula dr')
    expect(find_field(:city).value).to eq('Lake')
    expect(find_field(:state).value).to eq('Michigan')
    expect(find_field(:zip).value).to eq('77967')
    expect(find_field(:email).value).to eq('T-tar@gmail.com')
  end
end
