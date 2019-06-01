require 'rails_helper'

RSpec.describe "offers/show", type: :view do
  before(:each) do
    @offer = assign(:offer, Offer.create!(
      :origin => "Origin",
      :destination => "Destination",
      :user_id => 2,
      :maximum_intake => 3,
      :status => 4,
      :offer_id => 5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Origin/)
    expect(rendered).to match(/Destination/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
  end
end
