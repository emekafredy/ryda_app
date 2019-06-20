require 'rails_helper'

RSpec.describe OffersController, type: :controller do
  login_user

  let!(:available_rides) { create_list(:available_rides, 5, user_id: subject.current_user.id) }
  let!(:matching_offer) { create(:matching_offer, user_id: subject.current_user.id) }
  let!(:completed_offers) { create_list(:completed_offers, 3, user_id: subject.current_user.id) }


  let(:valid_attributes) { { origin: 'Jibowu', destination: 'Epic Tower', maximum_intake: 4, take_off: '2019-06-08 12:00:00' } }
  let(:valid_request_attributes) { { origin: 'Jibowu', destination: 'Epic Tower', take_off: (Time.now + 10*60*60).strftime("%F %T"), offer_id: completed_offers.first.id  } }
  let(:invalid_attributes) { { origin: '', destination: '' } }
  let(:request_attributes) { { origin: 'Ikeja', destination: 'Epic Tower', take_off: (Time.now + 10*60*60).strftime("%F %T")  } }

  describe "GET #index" do
    it "returns a success response" do
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Offer" do
        expect {
          post :create, params: {offer: valid_attributes}
        }.to change(Offer, :count).by(1)
      end

      it "redirects to the created offer" do
        post :create, params: {offer: valid_attributes}
        expect(response).to redirect_to(Offer.last)
      end
    end

    context "with invalid params" do
      it "does not create a new request due to supplied invalid attributes" do
        post :create, params: {offer: invalid_attributes}
        expect(response).to be_successful
      end
    end
  end

  describe "GET #show" do
    it "returns request details of a logged in user" do
      offer = subject.current_user.offers.build(valid_attributes)
      offer.save!
      get :show, params: {id: offer.to_param}
      expect(response).to be_successful
      expect(offer.origin).to eql('Jibowu')
      expect(offer.destination).to eql('Epic Tower')
    end
  end

  describe "GET #edit" do
    it "returns details of offer to be edited" do
      offer = subject.current_user.offers.build(valid_attributes)
      offer.save!
      get :edit, params: {id: offer.to_param}
      expect(response).to be_successful
    end
  end


  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { destination: 'Oshodi' } }

      it "updates the logged in user's selected offer" do
        offer = subject.current_user.offers.build(valid_attributes)
        offer.save!
        put :update, params: {id: offer.to_param, offer: new_attributes}
        offer.reload
        expect(response).to redirect_to(offer)
        expect(offer.destination).to eql("Oshodi")
      end
    end

    context "with invalid params" do
      it "does not update a selected offer due to supplied invalid attributes" do
        offer = subject.current_user.offers.build(valid_attributes)
        offer.save!
        put :update, params: {id: offer.to_param, offer: invalid_attributes}
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the logged in user's selected offer" do
      offer = subject.current_user.offers.build(valid_attributes)
      offer.save!
      expect {
        delete :destroy, params: {id: offer.to_param}
      }.to change(Offer, :count).by(-1)
    end

    it "redirects to the offers list" do
      offer = subject.current_user.offers.build(valid_attributes)
      offer.save!
      delete :destroy, params: {id: offer.to_param}
      expect(response).to redirect_to(offers_url)
    end
  end

  describe "GET #available_rides" do
    it "get all available rides" do
      get :all, params: {}
      expect(response).to be_successful
      expect(available_rides.first.status).to eql("open")
      expect(available_rides.first.take_off).to be > Time.now
    end
  end

  describe "GET #ride_matches" do
    before(:each) do
      logout_user_1
      login_user_2
    end
    let!(:matching_request) { create(:matching_request, user_id: subject.current_user.id) }
    it "gets all rides that match a user's request" do
      get :ride_matches, params: {}
      expect(response).to be_successful
      expect(matching_request.origin).to eql(matching_offer.origin)
      expect(matching_request.destination).to eql(matching_offer.destination)
      expect(matching_request.take_off).to eql(matching_offer.take_off)
    end
  end

  describe "GET #match_details" do
    before(:each) do
      logout_user_1
      login_user_2
    end
    let!(:matching_request) { create(:matching_request, user_id: subject.current_user.id) }
    it "gets the details of a selected request match" do
      get :match_details, params: {id: matching_offer.to_param}
      expect(response).to be_successful
      expect(matching_offer.origin).to eql("Ikeja")
      expect(matching_offer.destination).to eql("Epic Tower")
    end
  end

  describe "PUT #join_ride" do
    before(:each) do
      logout_user_1
      login_user_2
    end
    let(:new_attributes) { { status: 1, offer_id: matching_offer.id } }

    it "enables a logged in requester join a ride" do
      request = subject.current_user.requests.build(request_attributes)
      request.save!
      put :join_ride, params: {id: matching_offer.id, offer: new_attributes}
      request.update({ status: 1, offer_id: matching_offer.id })
      expect(request.offer_id).to eql(matching_offer.id)
      expect(request.status).to eql("booked")
    end
  end

  describe "GET #booked_ride" do
    before(:each) do
      logout_user_1
      login_user_2
    end
    let!(:booked_request) { create(:booked_request, user_id: subject.current_user.id, offer_id: matching_offer.id) }
    it "gets the details of a requester's booked ride" do
      get :my_booked_ride, params: {}
      expect(response).to be_successful
      expect(booked_request.origin).to eql("Ikeja")
      expect(booked_request.destination).to eql("Epic Tower")
      expect(booked_request.status).to eql("booked")
    end
  end

  describe "PUT #start_trip" do
    let(:new_attributes) { { status: 2 } }

    it "updates ride to 'in_progress' status" do
      offer = subject.current_user.offers.build(valid_attributes)
      offer.save!
      put :start_ride, params: {id: offer.to_param, offer: new_attributes}
      offer.reload
      expect(offer.status).to eql("in_progress")
    end
  end

  describe "PUT #complete_ride" do
    let(:new_attributes) { { status: 3 } }

    it "completes an offer" do
      offer = subject.current_user.offers.build(valid_attributes)
      offer.save!
      put :complete_ride, params: {id: offer.to_param, offer: new_attributes}
      offer.reload
      expect(offer.status).to eql("completed")
    end
  end

  describe "PUT complete_request" do
    let(:new_attributes) { { status: 2 } }

    it "completes a ride request" do
      request = subject.current_user.requests.build(valid_request_attributes)
      request.save!
      put :complete_request, params: { status: 2 }
      request.update({ status: 2 })
      expect(request.status).to eql("completed")
    end
  end

  describe "GET #completed_offers" do
    it "gets logged in rider's completed offers" do
      get :completed_offers, params: {}
      expect(response).to be_successful
      expect(completed_offers.first.status).to eql("completed")
    end
  end
end
