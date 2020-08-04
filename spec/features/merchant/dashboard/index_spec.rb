require "rails_helper"

RSpec.describe "Merchant Dashboard" do
  describe "As a merchant" do
    before :each do
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 1, merchant: @dog_shop)
      allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
    end

    it "displays the name and full address of the merchant they work for" do
      visit "/merchant/dashboard"
      expect(page).to have_content(@dog_shop.name)
      expect(page).to have_content(@dog_shop.address)
      expect(page).to have_content(@dog_shop.city)
      expect(page).to have_content(@dog_shop.state)
      expect(page).to have_content(@dog_shop.zip)
    end

    it "displays a link to view merchant's items" do
      visit "/merchant/dashboard"
      click_on "My Items"
      expect(current_path).to eq("/merchant/items")
    end

    it "displays order grandtotal" do
      pencil = @dog_shop.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @dog_shop.discounts.create!(percent: 10, quantity: 10)
      cart = Cart.new({pencil.id.to_s => 10})
      john = User.create!(name: "John", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "dog", password: "password", role: 0)
      order_1 = john.orders.create!(name: "John", address: "124 Lickit dr", city: "Denver", state: "Colorado", zip: 80890)
      ItemOrder.create!(item: pencil, order: order_1, quantity: 10, price: cart.discount_price(pencil))

      visit "/merchant/dashboard"

      expect(page).to have_content("Grand Total: $18.00")

      click_on "#{order_1.id}"

      expect(current_path).to eq("/merchant/orders/#{order_1.id}")

      expect(page).to have_content("Price: $1.80")
    end
  end
end
