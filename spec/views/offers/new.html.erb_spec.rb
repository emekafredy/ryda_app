require 'rails_helper'

RSpec.describe "offers/new", type: :view do
  before(:each) do
    assign(:offer, Offer.new(
      :origin => "MyString",
      :destination => "MyString",
      :user_id => 1,
      :maximum_intake => 1,
      :status => 1,
      :offer_id => 1
    ))
  end

  it "renders new offer form" do
    render

    assert_select "form[action=?][method=?]", offers_path, "post" do

      assert_select "input[name=?]", "offer[origin]"

      assert_select "input[name=?]", "offer[destination]"

      assert_select "input[name=?]", "offer[user_id]"

      assert_select "input[name=?]", "offer[maximum_intake]"

      assert_select "input[name=?]", "offer[status]"

      assert_select "input[name=?]", "offer[offer_id]"
    end
  end
end
