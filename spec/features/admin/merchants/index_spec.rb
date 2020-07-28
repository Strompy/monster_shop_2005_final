require "rails_helper"

RSpec.describe "Merchants Index Page" do
  describe "As an Admin" do
    before :each do
      @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 2)
      allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
      @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    end

    it "can disable a merchant account" do
      visit "/admin/merchants"
      within(".merchants-#{@dog_shop.id}") do
        expect(page).to have_button("Disable")
        click_on "Disable"
        expect(current_path).to eq("/admin/merchants")
        expect(page).to have_content("Disabled")
      end
      expect(page).to have_content("Merchant has been disabled")
    end

    it "can inactivate disabled merchant's items" do
      visit "/items/#{@pull_toy.id}"
      expect(page).to have_content("Active")
      visit "/admin/merchants"
      within(".merchants-#{@dog_shop.id}") do
        expect(page).to have_button("Disable")
        click_on "Disable"
      end
      visit "/items/#{@pull_toy.id}"
      expect(page).to have_content("Inactive")
    end

    it "can enable a merchant account" do
      visit "/admin/merchants"
      within(".merchants-#{@dog_shop.id}") do
        click_on "Disable"
        expect(page).to have_button("Enable")
        click_on "Enable"
        expect(current_path).to eq("/admin/merchants")
        expect(page).to have_content("Enabled")
      end
      expect(page).to have_content("Merchant's account is now enabled")
    end

    it "can activate enabled merchant's items" do
      visit "/admin/merchants"
      within(".merchants-#{@dog_shop.id}") do
        click_on "Disable"
        expect(page).to have_content("Disabled")
      end
      visit "/items/#{@pull_toy.id}"
      expect(page).to have_content("Inactive")
      visit "/admin/merchants"
      within(".merchants-#{@dog_shop.id}") do
        click_on "Enable"
        expect(page).to have_content("Enabled")
        expect(current_path).to eq("/admin/merchants")
      end
      visit "/items/#{@pull_toy.id}"
      expect(page).to have_content("Active")
    end
  end
end
