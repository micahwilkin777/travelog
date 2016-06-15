class CreateAccountDocuments < ActiveRecord::Migration
  def change
    create_table :account_documents do |t|
    	t.references :store_setting, index: true
    	t.string :ic_passport
    	t.string :bank
    	t.string :business
      t.timestamps null: false
    end
  end
end
