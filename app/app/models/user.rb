class User < ApplicationRecord
  has_many :posts
  has_many :comments
  has_many :ratings
  has_many :rateds, foreign_key: 'commenter_id', class_name: 'Comment'

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, presence: true
end
