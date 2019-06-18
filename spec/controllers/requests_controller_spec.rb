require 'rails_helper'

RSpec.describe RequestsController, type: :controller do
  login_user
  let!(:requests) { create_list(:request, 2, user_id: subject.current_user.id) }

  let(:valid_attributes) {
    { origin: 'Ikeja', destination: 'Epic Tower', take_off: '2019-06-08 12:00:00' }
  }

  let(:completed_request_attributes) {
    { origin: 'Ikeja', destination: 'Epic Tower', take_off: '2019-06-08 12:00:00', status: :completed }
  }

  let(:invalid_attributes) {
    { origin: '', destination: '', take_off: '2019-06-08 12:00:00' }
  }


  describe "GET #index" do
    it "gets user's requests" do
      get :index, params: {}
      expect(response).to be_successful
      expect(requests.first.user_id).to eq(subject.current_user.id)
    end
  end

  describe "GET #new" do
    it "renders the new request page" do
      get :new, params: {}
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Request" do
        expect {
          post :create, params: {request: valid_attributes}
        }.to change(Request, :count).by(1)
      end

      it "redirects to the created request" do
        post :create, params: {request: valid_attributes}
        expect(response).to redirect_to(Request.last)
      end
    end

    context "with invalid params" do
      it "does not create a new request due to supplied invalid attributes" do
        post :create, params: {request: invalid_attributes}
        expect(response).to be_successful
      end
    end
  end

  describe "GET #show" do
    it "returns request details of a logged in user" do
      request = subject.current_user.requests.build(valid_attributes)
      request.save!
      get :show, params: {id: request.id}
      expect(response).to be_successful
      expect(request.origin).to eql('Ikeja')
      expect(request.destination).to eql('Epic Tower')
    end
  end

  describe "GET #edit" do
    it "returns details of request to be edited" do
      request = subject.current_user.requests.build(valid_attributes)
      request.save!
      get :edit, params: {id: request.to_param}
      expect(response).to be_successful
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { origin: 'Jibowu' } }

      it "updates the logged in user's selected request" do
        request = subject.current_user.requests.build(valid_attributes)
        request.save!
        put :update, params: {id: request.to_param, request: new_attributes}
        request.reload
        expect(response).to redirect_to(request)
        expect(request.origin).to eql("Jibowu")
      end
    end

    context "with invalid params" do
      it "does not update a selected request due to supplied invalid attributes" do
        request = subject.current_user.requests.build(valid_attributes)
        request.save!
        put :update, params: {id: request.to_param, request: invalid_attributes}
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the logged in user's selected request" do
      request = subject.current_user.requests.build(valid_attributes)
      request.save!
      expect {
        delete :destroy, params: {id: request.to_param}
      }.to change(Request, :count).by(-1)
    end

    it "redirects user to the requests list" do
      request = subject.current_user.requests.build(valid_attributes)
      request.save!
      delete :destroy, params: {id: request.to_param}
      expect(response).to redirect_to(requests_url)
    end
  end

  describe "GET #completed_requests" do
    it "gets logged in requester's completed rides" do
      request = subject.current_user.requests.build(completed_request_attributes)
      request.save!
      get :completed_requests, params: {}
      expect(response).to be_successful
    end
  end
end
