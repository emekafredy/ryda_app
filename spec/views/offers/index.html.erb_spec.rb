require 'rails_helper'

RSpec.describe "offers/index", type: :view do
  # before(:each) do
  #   assign(:offers, [
  #     Offer.create!(
  #       :origin => "Origin",
  #       :destination => "Destination",
  #       :user_id => 2,
  #       :maximum_intake => 3,
  #       :status => 4,
  #       :offer_id => 5
  #     ),
  #     Offer.create!(
  #       :origin => "Origin",
  #       :destination => "Destination",
  #       :user_id => 2,
  #       :maximum_intake => 3,
  #       :status => 4,
  #       :offer_id => 5
  #     )
  #   ])
  # end
  #
  # it "renders a list of offers" do
  #   render
  #   assert_select "tr>td", :text => "Origin".to_s, :count => 2
  #   assert_select "tr>td", :text => "Destination".to_s, :count => 2
  #   assert_select "tr>td", :text => 2.to_s, :count => 2
  #   assert_select "tr>td", :text => 3.to_s, :count => 2
  #   assert_select "tr>td", :text => 4.to_s, :count => 2
  #   assert_select "tr>td", :text => 5.to_s, :count => 2
  # end
end
