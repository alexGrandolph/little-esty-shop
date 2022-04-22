class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :discounts
  has_many :invoice_items, through: :items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy
  has_many :customers, through: :invoices, dependent: :destroy
  has_many :transactions, through: :invoices, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :created_at
  validates_presence_of :updated_at
  enum status: {enabled: 0, disabled: 1}


  def top_five_customers
    customers.joins(invoices: :transactions)
              .where(transactions: { result: 0})
              .select('customers.*, count(transactions.*) as total_transactions')
              .order(total_transactions: :desc)
              .group('customers.id')
              .limit(5)
  end

  def ready_to_ship
    invoice_items.joins(:invoice).where.not(status: 2).order('invoices.created_at')
  end


  def unique_invoices
    invoices.uniq
  end


  def current_invoice_items(invoice_id)
    invoice_items.where(invoice_id: invoice_id)
  end

  def total_revenue_for_invoice(invoice_id)
    invoice = Invoice.find(invoice_id)
    invoice.invoice_items.sum('unit_price * quantity') / 100.to_f
  end


  def self.status_enabled
    where(status: 0)
  end

  def self.status_disabled
    where(status: 1)
  end

  def enabled_items
    items.where(status: 1)
  end

  def disabled_items
    items.where(status: 0)
  end

  def top_five_items
    items.joins(invoice_items: [invoice: :transactions])
    .where(transactions: {result: 0})
    .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_sales')
    .order(total_sales: :desc)
    # .order('items.*, sum(invoice_items.quantity * invoice_items.unit_price)')
    .group(:id)
    .limit(5)

  end

  def self.top_5_by_revenue
    joins(:invoices, [:transactions, :invoice_items])
    .where(transactions: {result: 0})
    .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price / 100.00) AS total_revenue")
    .group(:id)
    .order('total_revenue DESC')
    .limit(5)

  end

  def top_revenue_day
    invoices.joins(:transactions, :invoice_items)
    .where(transactions: {result: 0})
    .select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
    .group(:id)
    .order(total_revenue: :desc, created_at: :desc)
    .first.created_at.to_datetime
  end

  def discounted_revenue_for_invoice(invoice_id)
    invoice = Invoice.find(invoice_id)
    invoice.invoice_items.sum('unit_price * quantity') / 100.to_f
  end
end
