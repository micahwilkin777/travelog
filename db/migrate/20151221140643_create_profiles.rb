class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
    	t.references :user, index: true
    	t.string :first_name
    	t.string :last_name
    	t.string :avatar
    	t.date :birthday
    	t.integer :gender, :limit => 1
    	t.text :bio
      t.timestamps null: false
    end
  end
end
