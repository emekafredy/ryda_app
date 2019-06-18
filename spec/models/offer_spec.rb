require 'rails_helper'

RSpec.describe Offer, type: :model do
  it { should have_many(:requests) }
  it { should belong_to(:user) }
  # it { should validate_presence_of(:origin) }
  # it { should validate_presence_of(:destination) }
  # it { should validate_presence_of(:maximum_intake) }
end
