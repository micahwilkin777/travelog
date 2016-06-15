class CreateContactDetails < ActiveRecord::Migration
  def change
    create_table :contact_details do |t|
    	t.references :invoice, index: true
    	t.string :first_name
    	t.string :last_name
    	t.string :email
    	t.string :phone_number
    	t.text :message
      t.timestamps null: false
    end

    remove_column :invoices, :billing_email, :string
    remove_column :invoices, :billing_phone, :string
    remove_column :invoices, :billing_first_name, :string
    remove_column :invoices, :billing_last_name, :string
    
  end
end
