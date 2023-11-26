class Tag < ApplicationRecord
  has_many :ticket_tags
  has_many :tickets, through: :ticket_tags

  validates_presence_of :name

  def self.highest_count_tag
    order(count: :desc).first
  end
end
