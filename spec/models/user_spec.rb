require 'rails_helper'

RSpec.describe User, type: :model do
  OmniAuth.config.test_mode = true

  context "check user associations" do
    it { should have_many(:requests) }
    it { should have_many(:offers) }
  end

  it "creates or updates user from an oauth hash" do
    auth = {
      provider: "google_oauth2",
      uid: "899803897879380",
      info: {
        name: "John Doe",
        email: "john.doe@example.com",
        first_name: "John",
        last_name: "Doe",
        image: "https://lh4.googleusercontent.com/photo.jpg"
      },
      credentials: {
        token: "k90oitoi093o0292od9u0i908hiy94ji90ouo498u9u3u",
        refresh_token: "iuo9uu49iu038u903jhc8",
        expires_at: DateTime.now,
        expires: true
      }
    }
    new_user = User.create_from_provider_data(auth)

    expect(new_user.provider).to eq("google_oauth2")
    expect(new_user.uid).to eq("899803897879380")
    expect(new_user.email).to eq("john.doe@example.com")
    expect(new_user.first_name).to eq("John")
    expect(new_user.last_name).to eq("Doe")
  end
end
