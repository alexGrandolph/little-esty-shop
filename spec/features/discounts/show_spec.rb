require 'rails_helper'

RSpec.describe 'Merchant Discount Show' do

it "has the bulk discount's percentage and threshold" do
  merch1 = Merchant.create!(name: 'Jeffs Gold Blooms', created_at: Time.now, updated_at: Time.now)
  merch2 = Merchant.create!(name: 'Miyazakis Dark Souls', created_at: Time.now, updated_at: Time.now)
  discount_1 = Discount.create!(percent: 10, threshold: 20, merchant_id: merch1.id)
  discount_2 = Discount.create!(percent: 20, threshold: 30, merchant_id: merch1.id)
  discount_3 = Discount.create!(percent: 15, threshold: 25, merchant_id: merch2.id)
  
  visit "/merchants/#{merch1.id}/discounts/#{discount_1.id}"

  expect(page).to_not have_content("Percent: 20%")
  expect(page).to_not have_content("Threshold: 30")
  expect(page).to_not have_content("Percent: 15%")
  expect(page).to_not have_content("Threshold: 25")

  expect(page).to have_content("Percent: 10%")
  expect(page).to have_content("Threshold: 20")
  end

  it "has a link to a form to edit the discount" do
    merch1 = Merchant.create!(name: 'Jeffs Gold Blooms', created_at: Time.now, updated_at: Time.now)
    merch2 = Merchant.create!(name: 'Miyazakis Dark Souls', created_at: Time.now, updated_at: Time.now)
    discount_1 = Discount.create!(percent: 10, threshold: 20, merchant_id: merch1.id)
    discount_2 = Discount.create!(percent: 20, threshold: 30, merchant_id: merch1.id)
    discount_3 = Discount.create!(percent: 15, threshold: 25, merchant_id: merch2.id)
    
    visit "/merchants/#{merch1.id}/discounts/#{discount_1.id}"

    expect(page).to_not have_content("Percent: 40%")
    expect(page).to_not have_content("Threshold: 50")
    
    click_link 'Edit Discount'

    expect(page).to have_field('Percent', with: "10")
    expect(page).to have_field('Threshold', with: "20")
    
    fill_in 'Percent', with: '40'
    fill_in 'Threshold', with: '50'
    click_button 'Update'
    
    expect(current_path).to eq("/merchants/#{merch1.id}/discounts/#{discount_1.id}")
    expect(page).to have_content("Percent: 40%")
    expect(page).to have_content("Threshold: 50")
    expect(page).to_not have_content("Percent: 10%")
    expect(page).to_not have_content("Threshold: 20")
  end
end
# As a merchant
# When I visit my bulk discount show page
# Then I see a link to edit the bulk discount
# When I click this link
# Then I am taken to a new page with a form to edit the discount
# And I see that the discounts current attributes are pre-poluated in the form
# When I change any/all of the information and click submit
# Then I am redirected to the bulk discount's show page
# And I see that the discount's attributes have been updated