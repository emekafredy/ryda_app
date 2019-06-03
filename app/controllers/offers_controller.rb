class OffersController < ApplicationController
  before_action :set_offer, only: [:show, :edit, :update, :destroy]

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
    @all_offers = Offer.all.order("created_at DESC")
    @current_offers = @all_offers.select{ |offer| offer[:take_off].strftime("%F %T") > Time.now.strftime("%F %T") }
  end

  def get_current_user_requests
    @all_requests = Request.where(user_id: current_user.id).order("created_at DESC")
    @all_requests.select{ |request| request[:take_off].strftime("%F %T") > Time.now.strftime("%F %T") }
  end

  # GET /offers/all
  def all
    @current_offers = get_current_offers
    return @current_offers
  end

  def ride_matches
    @current_user_requests = get_current_user_requests

    @get_offers = Offer.where.not(user_id: current_user.id)
    @available_offers = @get_offers.select{ |offer| offer[:take_off].strftime("%F %T") > Time.now.strftime("%F %T") }
    @matches = []
    @current_user_requests.map do |request|
      @available_offers.map do |offer|
        if (request.origin == offer.origin) && (request.destination == offer.destination) && (request.take_off == offer.take_off)
          @matches << offer
        end
      end
    end

    puts 'LENGTH', @matches.length

    return @matches
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offer
      @offer = Offer.where(user_id: current_user.id).find(params[:id]) rescue not_found
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offer_params
      params.require(:offer).permit(:origin, :destination, :take_off, :maximum_intake)
    end
end
