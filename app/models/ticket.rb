class Ticket < ApplicationRecord
  has_many :ticket_tags, dependent: :destroy
  has_many :tags, through: :ticket_tags

  validates_presence_of :user_id, :title
  validate :less_than_five_tags

  def less_than_five_tags
    errors.add(:tags, 'can not have more than 5 tags') if tags.size > 5
  end
end
