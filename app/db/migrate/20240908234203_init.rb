class Init < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.string :github_username
      t.string :password
      
      t.datetime :registered_at, null: false

      t.timestamps

    end
    add_index :users, :email, unique: true

    create_table :posts do |t|
      t.string :title, null: false
      t.string :body, null: false
      t.references :user, null: false
      t.datetime :posted_at, null: false

      t.timestamps
    end

    create_table :ratings do |t|
      t.references :user, null: false
      t.references :rater, null: false, foreign_key: { to_table: :users }
      t.integer :rating, null: false
      t.datetime :rated_at, null: false

      t.timestamps
    end

    create_table :comments do |t|
      t.references :user, null: false
      t.references :post, null: false
      t.string :message
      t.datetime :commented_at, null: false

      t.timestamps
    end
  end
end
