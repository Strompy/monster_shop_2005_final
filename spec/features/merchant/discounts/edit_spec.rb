require "rails_helper"

RSpec.describe "Merchant Discount Edit Page" do
  before :each do
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @discount = @dog_shop.discounts.create!(percent: 5, quantity: 5)
    @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "merchant@example.com", password: "password", role: 1, merchant: @dog_shop)
    allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
  end
  it "is accessed from the discounts index and lets you edit the discount" do
    visit merchant_discounts_path

    click_on "Edit"

    expect(current_path).to eq("/merchant/discounts/#{@discount.id}/edit")

    fill_in :percent, with: 90
    fill_in :quantity, with: 100

    click_on "Edit Discount"

    expect(current_path).to eq(merchant_discounts_path)
    expect(page).to have_content("Discount Successfully Updated")

    @discount.reload
    visit merchant_discounts_path

    expect(page).to have_content("90%")
    expect(page).to have_content("100 items")
  end
  it "does not let you enter incorrect information" do
    visit merchant_discounts_path

    click_on "Edit"
    expect(current_path).to eq("/merchant/discounts/#{@discount.id}/edit")

    fill_in :percent, with: ""
    click_on "Edit Discount"
    expect(page).to have_content("Percent is not a number")

    fill_in :percent, with: "110"
    click_on "Edit Discount"
    expect(page).to have_content("Percent must be less than or equal to 100")

    fill_in :percent, with: "-10"
    click_on "Edit Discount"
    expect(page).to have_content("Percent must be greater than 0")

    fill_in :percent, with: "10"
    fill_in :quantity, with: ""
    click_on "Edit Discount"
    expect(page).to have_content("Quantity is not a number")

    fill_in :quantity, with: "k"
    click_on "Edit Discount"
    expect(page).to have_content("Quantity is not a number")

    fill_in :quantity, with: "-10"
    click_on "Edit Discount"
    expect(page).to have_content("Quantity must be greater than 0")
  end
end
