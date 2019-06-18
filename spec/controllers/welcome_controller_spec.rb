require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe "GET #index" do
    it "gets the welcome/landing page" do
      get :index, params: {}
      expect(response).to be_successful
    end
  end
end
