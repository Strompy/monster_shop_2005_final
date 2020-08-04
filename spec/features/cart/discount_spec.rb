require 'rails_helper'

RSpec.describe 'Cart show page with discounts' do
  before(:each) do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @mike.discounts.create!(percent: 10, quantity: 10)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    # visit "/items/#{@paper.id}"
    # click_on "Add To Cart"
    # visit "/items/#{@tire.id}"
    # click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"
    user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 0)
    allow_any_instance_of(ApplicationController).to receive(:user).and_return(user)
  end
  it "discounts are applied automatically" do
    visit "/cart"

    within "#cart-item-#{@pencil.id}" do
      fill_in :quantity, with: 10
      click_on "Update Quantity"
    end

    expect(current_path).to eq("/cart")
    expect(page).to have_content("Qualified for discount!")

    within "#cart-item-#{@pencil.id}" do
      expect(page).to have_content("$1.80")
      expect(page).to have_content("10")
      expect(page).to have_content("$18")
    end

    expect(page).to have_content("Total: $18.00")
  end
  it "Only qualifying merchants and quantities have discount applied" do
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"

    visit "/cart"
    within "#cart-item-#{@paper.id}" do
      fill_in :quantity, with: 10
      click_on "Update Quantity"
    end

    within "#cart-item-#{@tire.id}" do
      fill_in :quantity, with: 10
      click_on "Update Quantity"
    end

    within "#cart-item-#{@tire.id}" do
      expect(page).to have_content("$#{@tire.price}")
      expect(page).to_not have_content("$90")
    end

    within "#cart-item-#{@pencil.id}" do
      expect(page).to_not have_content("$1.80")
    end
  end
  it "discounts are no longer applied when decreasing item quantity" do
    visit "/cart"

    within "#cart-item-#{@pencil.id}" do
      fill_in :quantity, with: 15
      click_on "Update Quantity"
    end

    expect(current_path).to eq("/cart")
    expect(page).to have_content("Qualified for discount!")

    within "#cart-item-#{@pencil.id}" do
      expect(page).to have_content("$1.80")
      expect(page).to have_content("15")
      expect(page).to have_content("$27")
    end

    expect(page).to have_content("Total: $27.00")

    within "#cart-item-#{@pencil.id}" do
      fill_in :quantity, with: 5
      click_on "Update Quantity"
    end

    expect(current_path).to eq("/cart")
    expect(page).to_not have_content("Qualified for discount!")

    within "#cart-item-#{@pencil.id}" do
      expect(page).to_not have_content("$1.80")
      expect(page).to_not have_content("$18")
      expect(page).to have_content("$2.00")
      expect(page).to have_content("5")
      expect(page).to have_content("$10")
    end

    expect(page).to have_content("Total: $10.00")
  end
  it "many items that do not qualify individually dont qualifiy together" do
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"

    visit "/cart"
    within "#cart-item-#{@paper.id}" do
      fill_in :quantity, with: 7
      click_on "Update Quantity"
    end

    within "#cart-item-#{@pencil.id}" do
      fill_in :quantity, with: 7
      click_on "Update Quantity"
    end

    within "#cart-item-#{@paper.id}" do
      expect(page).to_not have_content("$18")
    end

    within "#cart-item-#{@pencil.id}" do
      expect(page).to_not have_content("$1.80")
    end
  end
  it "Only best discount gets applied" do
    @mike.discounts.create!(percent: 7, quantity: 10)

    visit "/cart"

    within "#cart-item-#{@pencil.id}" do
      fill_in :quantity, with: 10
      click_on "Update Quantity"
    end

    expect(current_path).to eq("/cart")
    expect(page).to have_content("Qualified for discount!")

    within "#cart-item-#{@pencil.id}" do
      expect(page).to have_content("$1.80")
      expect(page).to have_content("10")
      expect(page).to have_content("$18")
    end

    expect(page).to have_content("Total: $18.00")
  end
end
