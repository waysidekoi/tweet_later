class UsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, :password, :username, :user_token, :user_secret
      t.timestamps
    end
  end
end
