class Offer < ApplicationRecord
  enum status: [:open, :closed, :in_progress, :completed]

  after_initialize do
    if self.new_record?
      self.status ||= :open
    end
  end

  validates_presence_of :origin, :destination, :maximum_intake, message: "is required"

  belongs_to :user
  has_many :requests
end
