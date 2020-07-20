require 'rails_helper'

RSpec.describe "When I use the navbar to register a user" do
  it "takes me to a form to fill out info" do
    visit "/merchants"

    within 'nav' do
      click_link "Register"
    end

    expect(current_path).to eq('/register')

    fill_in :name, with: "Tanya"
    fill_in :address, with: "145 Uvula dr"
    fill_in :city, with: "Lake"
    fill_in :state, with: "Michigan"
    fill_in :zip, with: "77967"
    fill_in :email, with: "T-tar@gmail.com"
    fill_in :password, with: "Bangladesh134"
    fill_in :c_password, with: "Bangladesh134"
    click_on "Submit"

    expect(current_path).to eq('/profile')
    expect(page).to have_content("Welcome to the black market")
  end

  it "takes me to a form to fill out info" do
    visit "/merchants"

    within 'nav' do
      click_link "Register"
    end

    expect(current_path).to eq('/register')
    click_on "Submit"
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Address can't be blank")
    expect(page).to have_content("City can't be blank")
    expect(page).to have_content("State can't be blank")
    expect(page).to have_content("Zip can't be blank")
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")

    expect(current_path).to eq('/register')
  end
end
