class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :rater, foreign_key: 'rater_id', class_name: 'User'

  validates :user_id, presence: true
  validates :rater_id, presence: true
  validates :rating, numericality: { only_integer: true }
  validates :rating, comparison: { greater_than: 0, less_than: 6 }

  before_create :rated_at_date

  def rated_at_date
    self.rated_at = self.created_at
  end
end
