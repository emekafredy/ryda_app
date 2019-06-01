class Request < ApplicationRecord
  enum status: [:open, :booked, :completed]

  after_initialize do
    if self.new_record?
      self.status ||= :open
    end
  end

  validates_presence_of :origin, :destination, message: "is required"

  belongs_to :user
end
