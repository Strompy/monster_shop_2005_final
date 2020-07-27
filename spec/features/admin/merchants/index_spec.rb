require "rails_helper"

RSpec.describe "Merchants Index Page" do
  describe "As an Admin" do
    before :each do
      @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 2)
      allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
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
  end
end
