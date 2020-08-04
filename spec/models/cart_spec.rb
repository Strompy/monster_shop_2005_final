require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 2 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 3 )
      @cart = Cart.new({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end

    it '.contents' do
      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end

    it '.add_item()' do
      @cart.add_item(@hippo.id.to_s)

      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2,
        @hippo.id.to_s => 1
        })
    end

    it '.total_items' do
      expect(@cart.total_items).to eq(3)
    end

    it '.items' do
      expect(@cart.items).to eq({@ogre => 1, @giant => 2})
    end

    it '.total' do
      expect(@cart.total).to eq(120)
    end

    it '.subtotal()' do
      expect(@cart.subtotal(@ogre)).to eq(20)
      expect(@cart.subtotal(@giant)).to eq(100)
    end

    it '.cart_quantity(item)' do
      expect(@cart.cart_quantity(@giant)).to eq(2)
    end

    it ".best_discount(item)" do
      @megan.discounts.create!(percent: 7, quantity: 2)
      best = @megan.discounts.create!(percent: 10, quantity: 2)

      expect(@cart.best_discount(@giant)).to eq([best])
    end

    it ".gets_discount?(item)" do
      @megan.discounts.create!(percent: 10, quantity: 2)

      expect(@cart.gets_discount?(@giant)).to eq(true)
      expect(@cart.gets_discount?(@ogre)).to eq(false)
    end

    it ".discount_price(item)" do
      @megan.discounts.create!(percent: 10, quantity: 2)

      expect(@cart.discount_price(@giant)).to eq(45)
    end

    it ".discount_subtotal()" do
      @megan.discounts.create!(percent: 10, quantity: 2)

      expect(@cart.discount_subtotal(@giant)).to eq(90)
    end

    it "discount?" do
      expect(@cart.discount?).to eq(false)
    end

    it "discounted_total" do
      @megan.discounts.create!(percent: 10, quantity: 2)
      cart = Cart.new({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })

      expect(cart.discounted_total).to eq(110)
    end

    it '.total with discount' do
      @megan.discounts.create!(percent: 10, quantity: 2)
        
      expect(@cart.total).to eq(110)
    end
  end
end
