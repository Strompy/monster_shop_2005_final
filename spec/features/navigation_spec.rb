
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')
    end

    it "I can see a cart indicator on all pages with a count of all the items" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
    end

    it "displays a link to return to the welcome/home page of the application" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_link("Monster Shop")
        click_on "Monster Shop"
        expect(current_path).to eq("/")
      end
    end

    it "displays a link to my shopping cart" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_link("Cart")
        click_on "Cart"
        expect(current_path).to eq("/cart")
      end
    end

    it "displays a link to log in" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_link("Log in")
        click_on "Log in"
        expect(current_path).to eq("/login")
      end
    end

    it "displays a link to the user registration page" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_link("Register")
        click_on "Register"
        expect(current_path).to eq("/register")
      end
    end

    # it "I try to access any path that begins with the following, then I see a 404 error" do
    #   visit "/merchants"
    #   expect(page).to have_content("The page you were looking for doesn't exist.")
    #
    #   visit "/admin"
    #   expect(page).to have_content("The page you were looking for doesn't exist.")
    #
    #   visit "/profile"
    #   expect(page).to have_content("The page you were looking for doesn't exist.")
    # end
  end

  describe "As a User" do
    it "displays specific user navigation" do
      visit "/login"
      user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134", role: 0)

      expect(user.default?).to be_truthy

      fill_in :email, with: "T-tar@gmail.com"
      fill_in :password, with: "Bangladesh134"
      click_on "Log In"

      expect(page).to have_link("Monster Shop")
      expect(page).to have_link("All Items")
      expect(page).to have_link("All Merchants")
      expect(page).to have_link("Cart")
      expect(page).to have_link("My Profile")
      expect(page).to have_link("Log Out")
      expect(page).to_not have_link("Log In")
      expect(page).to have_content("You are logged in as #{user.name}")
    end

    it "displays specific merchant navigation" do
      visit "/login"
      user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134", role: 1)

      expect(user.merchant?).to be_truthy

      fill_in :email, with: "T-tar@gmail.com"
      fill_in :password, with: "Bangladesh134"
      click_on "Log In"

      expect(page).to have_link("Monster Shop")
      expect(page).to have_link("All Items")
      expect(page).to have_link("All Merchants")
      expect(page).to have_link("Cart")
      expect(page).to have_link("My Dashboard")
      expect(page).to have_link("Log Out")
      expect(page).to_not have_link("Log In")
    end
  end
end
