require "rails_helper"

RSpec.describe "Merchant Dashboard" do
  before :each do
    @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 1)
    allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
  end

  it "displays the name and full address of the merchant they work for" do
    visit "/merchant/dashboard"
    expect(page).to have_content(@user.name)
    expect(page).to have_content(@user.address)
    expect(page).to have_content(@user.city)
    expect(page).to have_content(@user.state)
    expect(page).to have_content(@user.zip)
  end
end
