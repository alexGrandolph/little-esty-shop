class Invoice < ApplicationRecord
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items, dependent: :destroy
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :merchants, through: :items

  enum status: [:cancelled, 'in progress', :completed]

  validates_presence_of :status
  validates_presence_of :created_at
  validates_presence_of :updated_at

  def customer_name
    first_name = "#{customer.first_name}"
    last_name ="#{customer.last_name}"
    "#{first_name} #{last_name}"
  end

  def self.incomplete_invoices
    joins(:invoice_items).where(status: [1]).order(:created_at)
  end

  def self.revenue_for_invoice(invoice_id)
    invoice = Invoice.find(invoice_id)
    invoice.invoice_items.sum('unit_price * quantity') / 100.to_f
  end


  def discounted_revenue_for_merchant(merchant)
    merchant.invoice_items.joins(:discounts)
    .where('invoice_items.quantity >= discounts.threshold')
    .select('invoice_items.id, max(invoice_items.quantity * invoice_items.unit_price * (discounts.percent / 100.0)) as total_discount')
    .group('invoice_items.id')
    .sum(&:total_discount)
  end
end
