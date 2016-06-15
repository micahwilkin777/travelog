class CreateProfileDocuments < ActiveRecord::Migration
  def change
    create_table :profile_documents do |t|
    	t.references :profile, index: true
    	t.string :document
    	t.string :name
      t.timestamps null: false
    end
  end
end
