class AddOrderUrlToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :order_url, :string
  end
end
