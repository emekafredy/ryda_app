require 'rails_helper'

RSpec.describe "requests/index", type: :view do
  # before(:each) do
  #   assign(:requests, [
  #     Request.create!(
  #       :origin => "Origin",
  #       :destination => "Destination",
  #       :user_id => 2,
  #       :status => 3,
  #       :offer_id => 4
  #     ),
  #     Request.create!(
  #       :origin => "Origin",
  #       :destination => "Destination",
  #       :user_id => 2,
  #       :status => 3,
  #       :offer_id => 4
  #     )
  #   ])
  # end
  #
  # it "renders a list of requests" do
  #   render
  #   assert_select "tr>td", :text => "Origin".to_s, :count => 2
  #   assert_select "tr>td", :text => "Destination".to_s, :count => 2
  #   assert_select "tr>td", :text => 2.to_s, :count => 2
  #   assert_select "tr>td", :text => 3.to_s, :count => 2
  #   assert_select "tr>td", :text => 4.to_s, :count => 2
  # end
end
