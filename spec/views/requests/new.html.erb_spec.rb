require 'rails_helper'

RSpec.describe "requests/new", type: :view do
  before(:each) do
    assign(:request, Request.new(
      :origin => "MyString",
      :destination => "MyString",
      :user_id => 1,
      :status => 1,
      :offer_id => 1
    ))
  end

  it "renders new request form" do
    render

    assert_select "form[action=?][method=?]", requests_path, "post" do

      assert_select "input[name=?]", "request[origin]"

      assert_select "input[name=?]", "request[destination]"

      assert_select "input[name=?]", "request[user_id]"

      assert_select "input[name=?]", "request[status]"

      assert_select "input[name=?]", "request[offer_id]"
    end
  end
end
