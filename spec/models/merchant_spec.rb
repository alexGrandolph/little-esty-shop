require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:created_at) }
    it { should validate_presence_of(:updated_at) }
  end

  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:discounts) }
  end

  describe 'instance and class methods' do

    it "#top_five_customers" do
      merchant_1 = create(:merchant)
          item = create(:item, merchant_id: merchant_1.id)
          # customer_1, 6 succesful transactions and 1 failed
          customer_1 = create(:customer)
          invoice_1 = create(:invoice, customer_id: customer_1.id, created_at: "2012-03-25 09:54:09 UTC")
          invoice_item_1 = create(:invoice_item, item_id: item.id, invoice_id: invoice_1.id, status: 2)
          transactions_list_1 = FactoryBot.create_list(:transaction, 6, invoice_id: invoice_1.id, result: 0)
          failed_1 = create(:transaction, invoice_id: invoice_1.id, result: 1)
          # customer_2 5 succesful transactions
          customer_2 = create(:customer)
          invoice_2 = create(:invoice, customer_id: customer_2.id, created_at: "2012-03-25 09:54:09 UTC")
          invoice_item_2 = create(:invoice_item, item_id: item.id, invoice_id: invoice_2.id, status: 2)
          transactions_list_2 = FactoryBot.create_list(:transaction, 5, invoice_id: invoice_2.id, result: 0)
          #customer_3 4 succesful
          customer_3 = create(:customer)
          invoice_3 = create(:invoice, customer_id: customer_3.id, created_at: "2012-03-25 09:54:09 UTC")
          invoice_item_3 = create(:invoice_item, item_id: item.id, invoice_id: invoice_3.id, status: 2)
          transactions_list_3 = FactoryBot.create_list(:transaction, 4, invoice_id: invoice_3.id, result: 0)
          #customer_6 1 succesful
          customer_6 = create(:customer)
          invoice_6 = create(:invoice, customer_id: customer_6.id, created_at: "2012-03-25 09:54:09 UTC")
          invoice_item_6 = create(:invoice_item, item_id: item.id, invoice_id: invoice_6.id, status: 2)
          transactions_list_6 = FactoryBot.create_list(:transaction, 1, invoice_id: invoice_6.id, result: 0)
          #customer_4 3 succesful
          customer_4 = create(:customer)
          invoice_4 = create(:invoice, customer_id: customer_4.id, created_at: "2012-03-25 09:54:09 UTC")
          invoice_item_4 = create(:invoice_item, item_id: item.id, invoice_id: invoice_4.id, status: 2)
          transactions_list_4 = FactoryBot.create_list(:transaction, 3, invoice_id: invoice_4.id, result: 0)
          #customer_5 2 succesful
          customer_5 = create(:customer)
          invoice_5 = create(:invoice, customer_id: customer_5.id, created_at: "2012-03-25 09:54:09 UTC")
          invoice_item_5 = create(:invoice_item, item_id: item.id, invoice_id: invoice_5.id, status: 2)
          transactions_list_5 = FactoryBot.create_list(:transaction, 2, invoice_id: invoice_5.id, result: 0)

          expect(merchant_1.top_five_customers).to eq([customer_1, customer_2, customer_3, customer_4, customer_5])
    end

    it 'returns #unique_invoices for a given merchant' do
      merch1 = FactoryBot.create(:merchant)
      item1 = FactoryBot.create(:item, merchant_id: merch1.id)
      item2 = FactoryBot.create(:item, merchant_id: merch1.id)
      item3 = FactoryBot.create(:item, merchant_id: merch1.id)
      cust1 = FactoryBot.create(:customer)

      invoice1 = FactoryBot.create(:invoice, customer_id: cust1.id)
      invoice_item_1 = FactoryBot.create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id)

      invoice2 = FactoryBot.create(:invoice, customer_id: cust1.id)
      invoice_item_2 = FactoryBot.create(:invoice_item, item_id: item2.id, invoice_id: invoice2.id)

      invoice3 = FactoryBot.create(:invoice, customer_id: cust1.id)
      invoice_item_3 = FactoryBot.create(:invoice_item, item_id: item1.id, invoice_id: invoice3.id)
      invoice_item_4 = FactoryBot.create(:invoice_item, item_id: item2.id, invoice_id: invoice3.id)

      expect(merch1.unique_invoices).to eq([invoice1, invoice2, invoice3])
    end

    it "#items_ready_to_ship" do
      merchant_1 = create(:merchant)
      item_1 = create(:item, merchant_id: merchant_1.id)
      item_2 = create(:item, merchant_id: merchant_1.id)
      customer = create(:customer)
      invoice = create(:invoice, customer_id: customer.id, status: 1)
      date_1 = 	"2015-02-08 09:54:09 UTC".to_datetime
      date_2 = 	"2020-02-21 09:54:09 UTC".to_datetime
      date_3 = 	"2018-03-12 09:54:09 UTC".to_datetime
      invoice_item_1 = create(:invoice_item, status: 0, item_id: item_1.id, invoice_id: invoice.id, created_at: date_1)
      invoice_item_2 = create(:invoice_item, status: 0, item_id: item_1.id, invoice_id: invoice.id, created_at: date_2)
      invoice_item_3 = create(:invoice_item, status: 0, item_id: item_1.id, invoice_id: invoice.id, created_at: date_3)

      expect(merchant_1.ready_to_ship[0]).to eq(invoice_item_1)
      expect(merchant_1.ready_to_ship[1]).to eq(invoice_item_2)
      expect(merchant_1.ready_to_ship[2]).to eq(invoice_item_3)
    end
    it '#current_invoice_items returns a merchants invoice items for a given invoice' do
      merch1 = FactoryBot.create(:merchant)
      merch2 = FactoryBot.create(:merchant)
      cust1 = FactoryBot.create(:customer)
      item1 = FactoryBot.create(:item, merchant_id: merch1.id)
      item2 = FactoryBot.create(:item, merchant_id: merch1.id)
      item3 = FactoryBot.create(:item, merchant_id: merch1.id)
      item4 = FactoryBot.create(:item, merchant_id: merch2.id)

      invoice1 = FactoryBot.create(:invoice, customer_id: cust1.id)
      invoice_item_1 = FactoryBot.create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id)
      invoice_item_2 = FactoryBot.create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id)
      invoice_item_4 = FactoryBot.create(:invoice_item, item_id: item3.id, invoice_id: invoice1.id)
      invoice_item_3 = FactoryBot.create(:invoice_item, item_id: item4.id, invoice_id: invoice1.id)

      invoice2 = FactoryBot.create(:invoice, customer_id: cust1.id)
      invoice_item_5 = FactoryBot.create(:invoice_item, item_id: item2.id, invoice_id: invoice2.id)

      # require "pry"; binding.pry
      expect(merch1.current_invoice_items(invoice1.id)).to eq([invoice_item_1, invoice_item_2, invoice_item_4])
    end

    it 'returns the total revenue for a merchant for a given invoice' do
      merch1 = FactoryBot.create(:merchant)
      cust1 = FactoryBot.create(:customer)
      item1 = FactoryBot.create(:item, unit_price: 75107, merchant_id: merch1.id)
      item2 = FactoryBot.create(:item, unit_price: 59999, merchant_id: merch1.id)
      item3 = FactoryBot.create(:item, unit_price: 65734, merchant_id: merch1.id)
      invoice1 = FactoryBot.create(:invoice, customer_id: cust1.id)
      invoice_item_1 = FactoryBot.create(:invoice_item, item_id: item1.id, unit_price: item1.unit_price, quantity: 3, invoice_id: invoice1.id)
      invoice_item_2 = FactoryBot.create(:invoice_item, item_id: item2.id, unit_price: item2.unit_price, quantity: 1, invoice_id: invoice1.id)
      invoice_item_3 = FactoryBot.create(:invoice_item, item_id: item3.id, unit_price: item3.unit_price, quantity: 2, invoice_id: invoice1.id)

      invoice2 = FactoryBot.create(:invoice, customer_id: cust1.id)
      invoice_item_5 = FactoryBot.create(:invoice_item, item_id: item2.id, invoice_id: invoice2.id)

      expect(merch1.total_revenue_for_invoice(invoice1.id)).to eq(4167.88)
    end

    it '#status_enabled returns all merchants with the status: enabled (0)' do
      date1 = "2020-02-08 09:54:09 UTC".to_datetime
      date2 = "2017-03-16 04:04:09 UTC".to_datetime
      date3 = "2012-08-07 01:44:09 UTC".to_datetime
      date4 = "2015-05-03 08:23:09 UTC".to_datetime
      date5 = "2021-01-11 12:55:09 UTC".to_datetime
      date6 = "2016-08-18 02:36:09 UTC".to_datetime
      date7 = "2016-11-18 02:36:09 UTC".to_datetime
      merch1 = Merchant.create!(name: 'Lord Eldens', created_at: date1, updated_at: date1, status: 0)
      merch2 = Merchant.create!(name: 'Jeffs GoldBlooms', created_at: date2, updated_at: date2, status: 1)
      merch3 = Merchant.create!(name: 'Souls Darkery', created_at: date3, updated_at: date3, status: 0)
      merch4 = Merchant.create!(name: 'My Dog Skeeter', created_at: date4, updated_at: date4, status: 1)
      merch5 = Merchant.create!(name: 'Corgi Town', created_at: date5, updated_at: date5, status: 0)
      merch6 = Merchant.create!(name: 'Cheese Company', created_at: date5, updated_at: date6, status: 1)
      merch7 = Merchant.create!(name: 'Brisket is Tasty', created_at: date7, updated_at: date7, status: 0)
      expect(Merchant.status_enabled).to eq([merch1, merch3, merch5, merch7])
    end

    it '#enabled_items' do
      merch1 = FactoryBot.create(:merchant)
      cust1 = FactoryBot.create(:customer)
      item1 = FactoryBot.create(:item, unit_price: 75107, merchant_id: merch1.id, status: 1)
      item2 = FactoryBot.create(:item, unit_price: 59999, merchant_id: merch1.id)
      item3 = FactoryBot.create(:item, unit_price: 65734, merchant_id: merch1.id, status: 1)

      expect(merch1.enabled_items).to eq([item1, item3])
    end

    it '#disabled_items' do
      merch1 = FactoryBot.create(:merchant)
      cust1 = FactoryBot.create(:customer)
      item1 = FactoryBot.create(:item, unit_price: 75107, merchant_id: merch1.id, status: 1)
      item2 = FactoryBot.create(:item, unit_price: 59999, merchant_id: merch1.id)
      item3 = FactoryBot.create(:item, unit_price: 65734, merchant_id: merch1.id, status: 1)

      expect(merch1.disabled_items).to eq([item2])

    end

    it '#status_disabled returns all merchants with the status: disabled (1)' do
      date1 = "2020-02-08 09:54:09 UTC".to_datetime
      date2 = "2017-03-16 04:04:09 UTC".to_datetime
      date3 = "2012-08-07 01:44:09 UTC".to_datetime
      date4 = "2015-05-03 08:23:09 UTC".to_datetime
      date5 = "2021-01-11 12:55:09 UTC".to_datetime
      date6 = "2016-08-18 02:36:09 UTC".to_datetime
      date7 = "2016-11-18 02:36:09 UTC".to_datetime
      merch1 = Merchant.create!(name: 'Lord Eldens', created_at: date1, updated_at: date1, status: 0)
      merch2 = Merchant.create!(name: 'Jeffs GoldBlooms', created_at: date2, updated_at: date2, status: 1)
      merch3 = Merchant.create!(name: 'Souls Darkery', created_at: date3, updated_at: date3, status: 0)
      merch4 = Merchant.create!(name: 'My Dog Skeeter', created_at: date4, updated_at: date4, status: 1)
      merch5 = Merchant.create!(name: 'Corgi Town', created_at: date5, updated_at: date5, status: 0)
      merch6 = Merchant.create!(name: 'Cheese Company', created_at: date5, updated_at: date6, status: 1)
      merch7 = Merchant.create!(name: 'Brisket is Tasty', created_at: date7, updated_at: date7, status: 0)
      expect(Merchant.status_disabled).to eq([merch2, merch4, merch6])
    end

    it '#top_5_by_revenue returns top 5 merchants by revenue' do
      
      merchant_1 = Merchant.create!(name: 'Lord Eldens', created_at: Time.now, updated_at: Time.now)
      item_1 = create(:item, name: 'Elden Ring', unit_price: 9999, merchant_id: merchant_1.id)
      customer_1 = create(:customer)
      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: Time.now, updated_at: Time.now)
      transaction_list_1 = Transaction.create!(credit_card_number: '103294023', credit_card_expiration_date: "342", result: 0, created_at: Time.now, updated_at: Time.now, invoice_id: invoice_1.id)
      transaction_list_12 = Transaction.create!(credit_card_number: '103294023', credit_card_expiration_date: "342", result: 1, created_at: Time.now, updated_at: Time.now, invoice_id: invoice_1.id)

      invoice_item_1 = create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, status: 2, quantity: 1, unit_price: 9999)

      merchant_2 = Merchant.create!(name: 'Jeffs GoldBlooms', created_at: Time.now, updated_at: Time.now)
      item_2 = create(:item, name: 'Bolden Gloom', unit_price: 8888, merchant_id: merchant_2.id)
      invoice_2 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: Time.now, updated_at: Time.now)
      transaction_list_2 = Transaction.create!(credit_card_number: '103294023', credit_card_expiration_date: "342", result: 0, created_at: Time.now, updated_at: Time.now, invoice_id: invoice_2.id)

      invoice_item_2 = create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id, status: 2, quantity: 1, unit_price: 8888)

      merchant_3 = Merchant.create!(name: 'Souls Darkery', created_at: Time.now, updated_at: Time.now)
      item_3 = create(:item, name: 'Orthopedic Insole', unit_price: 7777, merchant_id: merchant_3.id)
      invoice_3 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: Time.now, updated_at: Time.now)
      transaction_list_3 = Transaction.create!(credit_card_number: '103294023', credit_card_expiration_date: "342", result: 0, created_at: Time.now, updated_at: Time.now, invoice_id: invoice_3.id)

      invoice_item_3 = create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id, status: 2, quantity: 1, unit_price: 7777)

      merchant_4 = Merchant.create!(name: 'My Dog Skeeter', created_at: Time.now, updated_at: Time.now)
      item_4 = create(:item, name: 'Literally a Dog', unit_price: 12345, merchant_id: merchant_4.id)
      invoice_4 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: Time.now, updated_at: Time.now)
      transaction_list_4 = Transaction.create!(credit_card_number: '103294023', credit_card_expiration_date: "342", result: 0, created_at: Time.now, updated_at: Time.now, invoice_id: invoice_4.id)

      invoice_item_4 = create(:invoice_item, item_id: item_4.id, invoice_id: invoice_4.id, status: 2, quantity: 1, unit_price: 12345)

      merchant_5 = Merchant.create!(name: 'Corgi Town', created_at: Time.now, updated_at: Time.now)
      item_5 = create(:item, name: 'Whole Township', unit_price: 2355, merchant_id: merchant_5.id)
      invoice_5 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: Time.now, updated_at: Time.now)
      transaction_list_5 = Transaction.create!(credit_card_number: '103294023', credit_card_expiration_date: "342", result: 0, created_at: Time.now, updated_at: Time.now, invoice_id: invoice_5.id)
      invoice_item_5 = create(:invoice_item, item_id: item_5.id, invoice_id: invoice_5.id, status: 2, quantity: 1, unit_price: 2355)


      merchant_6 = Merchant.create!(name: 'Cheese Company', created_at: Time.now, updated_at: Time.now)
      item_6 = create(:item, name: 'Some Cheese', unit_price: 447896, merchant_id: merchant_6.id)
      item_7 = create(:item, name: 'Also Cheese', unit_price: 246735, merchant_id: merchant_6.id)
      invoice_6 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: Time.now, updated_at: Time.now)
      transaction_list_6 = Transaction.create!(credit_card_number: '103294023', credit_card_expiration_date: "342", result: 0, created_at: Time.now, updated_at: Time.now, invoice_id: invoice_6.id)

      invoice_item_6 = create(:invoice_item, item_id: item_6.id, invoice_id: invoice_6.id, status: 2, quantity: 1, unit_price: 447896)
      invoice_item_7 = create(:invoice_item, item_id: item_7.id, invoice_id: invoice_6.id, status: 1, quantity: 2, unit_price: 3242)

      expect(Merchant.top_5_by_revenue).to eq([merchant_6, merchant_4, merchant_1, merchant_2, merchant_3])

    end
  end

  it '#top_five_items' do
    merchant_1 = Merchant.create!(name: 'Lord Eldens', created_at: Time.now, updated_at: Time.now)
    customer_1 = create(:customer)
    item_9 = create(:item, name: 'Elden Ring', unit_price: 999, merchant_id: merchant_1.id)
    item_7 = create(:item, name: 'Demons Souls', unit_price: 888, merchant_id: merchant_1.id)
    item_11 = create(:item, name: 'Dark Souls 3', unit_price: 777, merchant_id: merchant_1.id)
    item_12 = create(:item, name: 'Doom', unit_price: 666, merchant_id: merchant_1.id)
    item_3 = create(:item, name: 'Bloodborne', unit_price: 555, merchant_id: merchant_1.id)
    item_1 = create(:item, name: 'Metal Gear', unit_price: 444, merchant_id: merchant_1.id)
    invoice_9 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: Time.now, updated_at: Time.now)
    invoice_7 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: Time.now, updated_at: Time.now)
    invoice_11 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: Time.now, updated_at: Time.now)
    invoice_12 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: Time.now, updated_at: Time.now)
    invoice_3 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: Time.now, updated_at: Time.now)
    invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: Time.now, updated_at: Time.now)
    transaction_9 = create(:transaction, invoice_id: invoice_9.id, result: 0)
    transaction_7 = create(:transaction, invoice_id: invoice_7.id, result: 0)
    transaction_11 = create(:transaction, invoice_id: invoice_11.id, result: 0)
    transaction_12 = create(:transaction, invoice_id: invoice_12.id, result: 0)
    transaction_3 = create(:transaction, invoice_id: invoice_3.id, result: 0)
    transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: 0)
    invoice_item_9 = create(:invoice_item, item_id: item_9.id, invoice_id: invoice_9.id, status: 2, quantity: 1, unit_price: 99)
    invoice_item_7 = create(:invoice_item, item_id: item_7.id, invoice_id: invoice_7.id, status: 2, quantity: 1, unit_price: 88)
    invoice_item_11 = create(:invoice_item, item_id: item_11.id, invoice_id: invoice_11.id, status: 2, quantity: 1, unit_price: 77)
    invoice_item_12 = create(:invoice_item, item_id: item_12.id, invoice_id: invoice_12.id, status: 2, quantity: 1, unit_price: 66)
    invoice_item_3 = create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id, status: 2, quantity: 1, unit_price: 55)
    invoice_item_1 = create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, status: 2, quantity: 1, unit_price: 44)

    merchant_1.top_five_items
    expect(merchant_1.top_five_items).to eq([item_9, item_7, item_11, item_12, item_3])
  end

  it "#top_revenue_day" do
    date_1 = 	"2015-02-08 09:54:09 UTC".to_datetime
    date_2 = 	"2020-02-21 09:54:09 UTC".to_datetime
    date_3 = 	"2018-03-12 09:54:09 UTC".to_datetime

    #merchant_1 sold 9999 on 02/08/2015
    merchant_1 = Merchant.create!(name: 'Lord Eldens', created_at: Time.now, updated_at: Time.now)
    item_1 = create(:item, name: 'Elden Ring', unit_price: 9999, merchant_id: merchant_1.id)
    customer_1 = create(:customer)
    invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: date_1, updated_at: Time.now)
    transaction_list_1 = Transaction.create!(credit_card_number: '103294023', credit_card_expiration_date: "342", result: 0, created_at: Time.now, updated_at: Time.now, invoice_id: invoice_1.id)
    transaction_list_12 = Transaction.create!(credit_card_number: '103294023', credit_card_expiration_date: "342", result: 1, created_at: Time.now, updated_at: Time.now, invoice_id: invoice_1.id)

    invoice_item_1 = create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, status: 2, quantity: 1, unit_price: 9999)

    #merchant_1 sold 8888 on 02/21/2020
    item_2 = create(:item, name: 'Bolden Gloom', unit_price: 8888, merchant_id: merchant_1.id)
    invoice_2 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: date_2, updated_at: Time.now)
    transaction_list_2 = Transaction.create!(credit_card_number: '103294023', credit_card_expiration_date: "342", result: 0, created_at: Time.now, updated_at: Time.now, invoice_id: invoice_2.id)

    invoice_item_2 = create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id, status: 2, quantity: 1, unit_price: 8888)

    #merchant_2 sold 7777 on 03/12/2018
    merchant_2 = Merchant.create!(name: 'Souls Darkery', created_at: Time.now, updated_at: Time.now)
    item_3 = create(:item, name: 'Orthopedic Insole', unit_price: 7777, merchant_id: merchant_2.id)
    invoice_3 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: date_3, updated_at: Time.now)
    transaction_list_3 = Transaction.create!(credit_card_number: '103294023', credit_card_expiration_date: "342", result: 0, created_at: Time.now, updated_at: Time.now, invoice_id: invoice_3.id)

    invoice_item_3 = create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id, status: 2, quantity: 1, unit_price: 7777)

    #merchant_2 sold 7777 on 02/08/2015
    item_4 = create(:item, name: 'Literally a Dog', unit_price: 7777, merchant_id: merchant_2.id)
    invoice_4 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: date_1, updated_at: Time.now)
    transaction_list_4 = Transaction.create!(credit_card_number: '103294023', credit_card_expiration_date: "342", result: 0, created_at: Time.now, updated_at: Time.now, invoice_id: invoice_4.id)

    invoice_item_4 = create(:invoice_item, item_id: item_4.id, invoice_id: invoice_4.id, status: 2, quantity: 1, unit_price: 7777)
    
    expect(merchant_1.top_revenue_day).to eq(date_1)
    expect(merchant_2.top_revenue_day).to eq(date_3)
  end
end
