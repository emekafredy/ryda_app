class RequestsController < ApplicationController
  before_action :authenticate_user
  before_action :set_request, only: [:show, :edit, :update, :destroy]

  def index
    @requests = Request.where(user_id: current_user.id).order("created_at DESC")
  end

  def show
  end

  def new
    @request = Request.new
  end

  def edit
    @request = Request.where(user_id: current_user.id, status: :open).find(params[:id]) rescue not_found
  end

  def create
    @request = current_user.requests.build(request_params)
    respond_to do |format|
      if @request.save
        format.html { redirect_to @request, success: 'Request successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to @request, success: 'Request successfully updated.' }
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url, success: 'Request successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def completed_requests
    @completed_requests = Request.where(user_id: current_user.id, status: :completed).order("created_at DESC")
  end

  private
    def set_request
      @request = Request.where(user_id: current_user.id).find(params[:id]) rescue not_found
      @user = current_user
    end

    def request_params
      params.require(:request).permit(:origin, :destination, :take_off)
    end
end
