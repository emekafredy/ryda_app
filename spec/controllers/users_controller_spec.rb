require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  login_user


  describe "GET #profile" do
    it "gets logged in user's profile" do
      get :profile, params: {}
      expect(response).to be_successful
      expect(subject.current_user.first_name).to eq("John")
      expect(subject.current_user.last_name).to eq("Doe")
    end
  end

  describe "PUT #update_phone_number" do
    context "with valid params" do
      let(:new_number) { { phone_number: 7736688932 } }

      it "updates logged in user's phone number" do
        put :update_phone_number, params: { user: new_number }
        subject.current_user.reload
        expect(subject.current_user.phone_number).to eq(7736688932)
      end
    end
  end
end
