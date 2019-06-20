class Request < ApplicationRecord
  enum status: [:open, :booked, :completed]
  validates_presence_of :origin, :destination, message: "is required"

  belongs_to :user

  after_initialize do
    if self.new_record?
      self.status ||= :open
    end
  end

  def self.get_requests(user)
    Request.where(user_id: user.id).order("created_at DESC")
  end
end
