class OffersController < ApplicationController
  before_action :authenticate_user
  before_action :set_offer, only: [:show, :edit, :update, :destroy, :start_ride, :complete_ride]
  before_action :set_match, only: [:match_details, :join_ride]
  before_action :booked_ride, only: [:my_booked_ride, :match_details, :complete_request]
  before_action :set_editable_offer, only: [:index, :show]

  def index
    @offers = Offer.get_offers(current_user)
  end

  def show
  end

  def new
    @offer = Offer.new
  end

  def edit
    @offer = Offer.where(user_id: current_user.id, status: :open).find(params[:id]) rescue not_found
  end

  def create
    @offer = current_user.offers.build(offer_params)
    respond_to do |format|
      if @offer.save
        format.html { redirect_to @offer, success: 'Offer successfully created.' }
        format.json { render :show, status: :created, location: @offer }
      else
        format.html { render :new }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @offer.update(offer_params)
        format.html { redirect_to @offer, success: 'Offer successfully updated.' }
        format.json { render :show, status: :ok, location: @offer }
      else
        format.html { render :edit }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @offer.destroy
    respond_to do |format|
      format.html { redirect_to offers_url, success: 'Offer successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def all
    @current_offers = Offer.get_current_offers
  end

  def ride_matches
    @matches = Offer.get_ride_matches(current_user)
  end

  def match_details
  end

  def join_ride
    if Offer.join_offered_ride(params, current_user)
      redirect_to offers_ride_matches_path
      flash[:success] = "You have succesfully joined the ride."
    else
      flash[:danger] = "Oops! You cannot join this ride. The passengers' seat is filled up"
    end
  end

  def my_booked_ride
  end

  def cancel_ride
    @request = Request.where(user_id: current_user.id, status: :booked)
    @request.update(offer_id: nil, status: 0)
    redirect_to offers_ride_matches_path
    flash[:success] = "You have cancelled the ride."
  end

  def start_ride
    @offer.update(status: 2)
    redirect_to @offer
    flash[:success] = "You have started this ride."
  end

  def complete_ride
    @offer.update(status: 3)
    redirect_to @offer
    flash[:success] = 'You have completed this ride.'
  end

  def complete_request
    @request = Request.where(user_id: current_user.id, status: :booked)
    @request.update(status: 2)
    redirect_to offers_my_booked_ride_path
    flash[:success] = 'You have completed this ride.'
  end

  def completed_offers
    @completed_offers = Offer.where(user_id: current_user.id, status: :completed).order("created_at DESC")
  end

  private
    def set_offer
      @offer = Offer.where(user_id: current_user.id).find(params[:id]) rescue not_found
      @user = current_user
      @no_of_passengers = if defined?(@offer.id) then Request.where(offer_id: @offer.id).length else nil end
    end

    def offer_params
      params.require(:offer).permit(:origin, :destination, :take_off, :maximum_intake)
    end

    def set_match
      @matches = ride_matches
      @ride_details = @matches.detect{ |ride| ride.id == (params[:id].to_i) } rescue not_found
      @user = User.find_by(id: @ride_details.user_id) rescue not_found
    end

    def booked_ride
      @user_request = Request.find_by(user_id: current_user.id, status: :booked)
      @passengers_no = Request.where(offer_id: (params[:id].to_i)).length
      if (@user_request)
        @ride = Offer.find_by(id: @user_request.offer_id)
        @user = User.find_by(id: @ride.user_id)
        @no_of_passengers = Request.where(offer_id: @ride.id).length
      end
    end

    def set_editable_offer
      Offer.editable_offer(current_user)
    end
end
