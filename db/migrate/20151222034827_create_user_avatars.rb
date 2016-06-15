class CreateUserAvatars < ActiveRecord::Migration
  def change
    create_table :user_avatars do |t|
    	t.references :profile, index: true
    	t.string :avatar
      t.timestamps null: false
    end
  end
end
