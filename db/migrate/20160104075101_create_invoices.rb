class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
    	t.references :product, index: true
    	t.date :booking_date
    	t.string :billing_country
    	t.integer :amount_cents
    	t.text :variants
    	t.integer :payment_type
    	t.integer :card_type
    	t.integer :valid_month
    	t.integer :valid_year
    	t.string :security_code
    	t.string :billing_first_name
    	t.string :billing_last_name
    	t.string :billing_postal_code
      t.string :currency
      t.integer :status, :limit => 1, :default => 0
      t.string :token
      t.string :payer_id
      t.timestamps null: false
    end
  end
end
