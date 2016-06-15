class CreateProductAttachments < ActiveRecord::Migration
  def change
    create_table :product_attachments do |t|
    	t.references :product, index: true
    	t.string :attachment
      t.timestamps null: false
    end
  end
end
