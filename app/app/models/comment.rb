class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :message, presence: true

  before_create :commented_at_date

  def commented_at_date
    self.commented_at = self.created_at
  end
end
