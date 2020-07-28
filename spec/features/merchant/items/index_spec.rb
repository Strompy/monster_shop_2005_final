require "rails_helper"

RSpec.describe "Merchant Items Index Page" do
  describe "As a merchant" do
    before :each do
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 1, merchant: @dog_shop)
      allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
      @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "can deactivate an item" do
      visit "/merchant/items"
      within(".items-#{@pull_toy.id}") do
        expect(page).to have_content(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content(@pull_toy.price)
        expect(page).to have_css("img[src=\"#{@pull_toy.image}\"]")
        expect(page).to have_content("active")
        expect(page).to have_content(@pull_toy.inventory)
        click_on "deactivate"
      end
      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("Item is no longer for sale")
      @pull_toy.reload
      visit "/merchant/items"
      within(".items-#{@pull_toy.id}") do
        expect(page).to have_content("inactive")
      end
    end

    it "can activate an item" do
      visit "/merchant/items"
      within(".items-#{@dog_bone.id}") do
        expect(page).to have_content("inactive")
        click_on "activate"
      end
      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("Item is now available for sale")
      @dog_bone.reload
      visit "/merchant/items"
      within(".items-#{@dog_bone.id}") do
        expect(page).to have_content("active")
      end
    end
  end
end
