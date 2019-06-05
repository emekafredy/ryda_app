class OffersController < ApplicationController
  before_action :set_offer, only: [:show, :edit, :update, :destroy, :start_ride, :complete_ride]
  before_action :set_match, only: [:match_details, :join_ride]
  before_action :booked_ride, only: [:my_booked_ride, :match_details, :complete_request]
  before_action :set_editable_offer, only: [:index, :show]

  # GET /offers
  # GET /offers.json
  def index
    @offers = Offer.where(user_id: current_user.id).order("created_at DESC")
  end

  # GET /offers/1
  # GET /offers/1.json
  def show
  end

  # GET /offers/new
  def new
    @offer = Offer.new
  end

  # GET /offers/1/edit
  def edit
    @offer = Offer.where(user_id: current_user.id, status:open).find(params[:id]) rescue not_found
  end

  # POST /offers
  # POST /offers.json
  def create
    @offer = current_user.offers.build(offer_params)

    respond_to do |format|
      if @offer.save
        format.html { redirect_to @offer, notice: 'Offer was successfully created.' }
        format.json { render :show, status: :created, location: @offer }
      else
        format.html { render :new }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offers/1
  # PATCH/PUT /offers/1.json
  def update
    respond_to do |format|
      if @offer.update(offer_params)
        format.html { redirect_to @offer, notice: 'Offer was successfully updated.' }
        format.json { render :show, status: :ok, location: @offer }
      else
        format.html { render :edit }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/1
  # DELETE /offers/1.json
  def destroy
    @offer.destroy
    respond_to do |format|
      format.html { redirect_to offers_url, notice: 'Offer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_current_offers
    @all_offers = Offer.where(status: :open).order("created_at DESC")
    @current_offers = @all_offers.select{ |offer| offer[:take_off].strftime("%F %T") > Time.now.strftime("%F %T") }
  end

  def get_current_user_requests
    @all_requests = Request.where(user_id: current_user.id).order("created_at DESC")
    @all_requests.select{ |request| request[:take_off].strftime("%F %T") > Time.now.strftime("%F %T") }
  end

  # GET /offers/all
  def all
    @current_offers = get_current_offers
  end

  def ride_matches
    @current_user_requests = get_current_user_requests
    @get_offers = Offer.where.not(user_id: current_user.id)
    @available_offers = @get_offers.select{ |offer| offer[:take_off].strftime("%F %T") > Time.now.strftime("%F %T") }
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

  def match_details
  end

  def join_ride
    @request = Request.where(user_id: current_user.id, status: :open)
    @request.update(offer_id: params[:id], status: 1)
    flash.notice = 'You have joined this ride.'
    redirect_to offers_ride_matches_path
  end

  def my_booked_ride
  end

  def cancel_ride
    @request = Request.where(user_id: current_user.id, status: :booked)
    @request.update(offer_id: nil, status: 0)
    flash.notice = 'You have cancel the ride.'
    redirect_to offers_ride_matches_path
  end

  def start_ride
    @offer.update(status: 2)
    flash.notice = 'You have started this ride.'
    redirect_to @offer
  end

  def complete_ride
    @offer.update(status: 3)
    flash.notice = 'You have completed this ride.'
    redirect_to @offer
  end

  def complete_request
    @request = Request.where(user_id: current_user.id, status: :booked)
    @request.update(status: 2)
    flash.notice = 'You have completed this ride.'
    redirect_to offers_my_booked_ride_path
  end

  def completed_offers
    @completed_offers = Offer.where(user_id: current_user.id, status: :completed).order("created_at DESC")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offer
      @offer = Offer.where(user_id: current_user.id).find(params[:id]) rescue not_found
      @user = current_user
      @no_of_passengers = Request.where(offer_id: @offer.id).length
    end

    # Never trust parameters from the scary internet, only allow the white list through.
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
      @user_offer = Offer.find_by(user_id: current_user.id, status: :open)
      if @user_offer
        @current_take_off = @user_offer.take_off.strftime("%F %T") > Time.now.strftime("%F %T")
        @passengers_exist = Request.where(offer_id: @user_offer.id).length > 0 && @current_take_off
        if @passengers_exist
          @editable_record = false
        else
          @editable_record = true
        end
      end
    end
end
