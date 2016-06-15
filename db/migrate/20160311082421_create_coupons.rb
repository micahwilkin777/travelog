class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
    	t.string :code
    	t.integer :amount_cents
    	t.string :currency
      t.timestamps null: false
    end
  end
end
