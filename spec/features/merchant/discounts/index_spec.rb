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
end
