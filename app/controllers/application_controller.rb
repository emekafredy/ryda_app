class ApplicationController < ActionController::Base
  before_action :set_open_user_rides

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  rescue
    render_404
  end

  def render_404
    render file: "#{Rails.root}/public/404", status: :not_found
  end

  def set_open_user_rides
    if (current_user)
      @existing_request = Request.where(user_id: current_user.id, status: [:open, :booked])
      @existing_offer = Offer.where(user_id: current_user.id, status: [:open, :closed, :in_progress])

      @request_exists = @existing_request.length > 0
      @offer_exists = @existing_offer.length > 0
    end
  end
end
