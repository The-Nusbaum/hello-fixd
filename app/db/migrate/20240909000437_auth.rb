class Auth < ActiveRecord::Migration[7.2]
  def change
    rename_column :users, :password, :password_digest

    create_table :api_keys do |t|
      t.references :user, null: false
      t.string :token_digest, null: false
      t.timestamps null: false
    end
    add_index :api_keys, :token_digest, unique: true
  end
end
