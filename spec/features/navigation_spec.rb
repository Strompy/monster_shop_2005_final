
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
  end
end
