class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :user_id, presence: true
  validates :title, presence: true
  validates :body, presence: true

  before_create :posted_at_date

  def posted_at_date
    self.posted_at = self.created_at
  end
end
