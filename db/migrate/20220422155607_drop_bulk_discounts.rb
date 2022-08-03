class DropBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    drop_table :bulk_discounts
  end
end
