require "rails_helper"

RSpec.describe "Merchant New Discounts Form" do
  before :each do
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "merchant@example.com", password: "password", role: 1, merchant: @dog_shop)
    allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
  end
  it "is accessed from the discounts index" do
    visit merchant_discounts_path

    expect(page).to have_link("Create New Discount")

    click_on "Create New Discount"

    expect(current_path).to eq("/merchant/discounts/new")

    fill_in :percent, with: 10
    fill_in :quantity, with: 10

    click_on "Submit"

    expect(current_path).to eq("/merchant/discounts")
    expect(page).to have_content("Discount Successfully Created")
    expect(page).to have_content("10% off")
    expect(page).to have_content("10 items")
  end
  it "when given incorrect information returns you to the form and tells you what you incorrectly submitted" do
    visit new_merchant_discount_path

    click_on "Submit"

    expect(page).to have_content("Quantity is not a number")
    expect(page).to have_content("Percent is not a number")

    fill_in :percent, with: 10
    click_on "Submit"
    expect(page).to have_content("Quantity is not a number")
    fill_in :quantity, with: 10
    click_on "Submit"
    expect(page).to have_content("Discount Successfully Created")

  end
end
