class RemoveAttachmentsFromProductsTable < ActiveRecord::Migration
  def change
  	remove_column :products, :attachments
  end
end
