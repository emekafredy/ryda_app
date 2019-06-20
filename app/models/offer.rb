class Offer < ApplicationRecord
  enum status: [:open, :closed, :in_progress, :completed]
  validates_presence_of :origin, :destination, :maximum_intake, message: "is required"

  belongs_to :user
  has_many :requests

  after_initialize do
    if self.new_record?
      self.status ||= :open
    end
  end

  def self.get_offers(user)
    Offer.where(user_id: user.id).order("created_at DESC")
  end

  # format returned time to be comparable
  def self.time_format(time)
    time.strftime("%F %T")
  end

  # get offers that are still valid for comparism
  def self.get_current_offers
    @all_offers = Offer.where(status: :open).order("created_at DESC")
    @current_offers = @all_offers.select{ |offer| time_format(offer[:take_off]) > time_format(Time.now) }
  end

  # get requests that are still valid for comparism
  def self.get_current_user_requests(user)
    @all_requests = Request.where(user_id: user.id).order("created_at DESC")
    @all_requests.select{ |request| time_format(request[:take_off]) > time_format(Time.now) }
  end

  def self.get_ride_matches(user)
    @current_user_requests = Offer.get_current_user_requests(user)
    @get_offers = Offer.where.not(user_id: user.id)
    @available_offers = @get_offers.select{ |offer| time_format(offer[:take_off]) > time_format(Time.now) }
    @matches = []
    @current_user_requests.map do |request|
      @available_offers.map do |offer|
        if (request.origin == offer.origin) && (request.destination == offer.destination) && (request.take_off == offer.take_off) && (request.status === "open")
          @matches << offer
        end
      end
    end
    return @matches
  end

  # join_ride method
  def self.join_offered_ride(params, user)
    @passengers_length = Request.where(offer_id: (params[:id].to_i)).length
    @maximum_ride_length = Offer.find(params[:id].to_i)
    @request = Request.where(user_id: user.id, status: :open)
    if @passengers_length < @maximum_ride_length.maximum_intake
      @request.update(offer_id: params[:id], status: 1)
    end
  end

  #set offers that are not yet concluded
  def self.editable_offer(user)
    @user_offer = Offer.find_by(user_id: user.id, status: :open)
    if @user_offer
      @current_take_off = time_format(@user_offer.take_off) > time_format(Time.now)
      @passengers_exist = Request.where(offer_id: @user_offer.id).length > 0 && @current_take_off
      if @passengers_exist
        @editable_record = false
      else
        @editable_record = true
      end
    end
  end

  #set user's booked ride
  def self.user_booked_ride(user, params)
    @user_request = Request.find_by(user_id: user.id, status: :booked)
    @passengers_no = Request.where(offer_id: (params[:id].to_i)).length
    if (@user_request)
      @ride = Offer.find_by(id: @user_request.offer_id)
      @user = User.find_by(id: @ride.user_id)
      @no_of_passengers = Request.where(offer_id: @ride.id).length
    end
  end
end
