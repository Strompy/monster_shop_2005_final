require "rails_helper"

RSpec.describe "Merchant Discounts Index" do
  before :each do
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "merchant@example.com", password: "password", role: 1, merchant: @dog_shop)
    allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
  end
  it "is accessed via a link from the dashboard" do
    visit "/merchant/dashboard"

    expect(page).to have_link("My Discounts")

    click_on "My Discounts"

    expect(current_path).to eq("/merchant/discounts")
  end
  it "Displays all existing discounts belonging to the merchant" do
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    bike_shop.discounts.create!(percent: 75, quantity: 1)

    @dog_shop.discounts.create!(percent: 5, quantity: 5)
    @dog_shop.discounts.create!(percent: 10, quantity: 10)
    @dog_shop.discounts.create!(percent: 50, quantity: 17)

    visit merchant_discounts_path

    expect(page).to have_content("5%")
    expect(page).to have_content("5 items")
    expect(page).to have_content("10%")
    expect(page).to have_content("10 items")
    expect(page).to have_content("50%")
    expect(page).to have_content("17 items")

    expect(page).to_not have_content("75%")
    expect(page).to_not have_content("1 items")
  end
  it "has a link to edit each discount" do
    @dog_shop.discounts.create!(percent: 5, quantity: 5)

    visit merchant_discounts_path

    expect(page).to have_link("Edit")
  end
end
