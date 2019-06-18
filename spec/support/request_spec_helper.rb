module RequestSpecHelper
  def json
    JSON.parse(response.body)
  end

  def stub_omniauth
    OmniAuth.config.test_mode = true
    auth_value = {
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

    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(auth_value)
    User.create_from_provider_data(auth_value)
  end

  def stub_omniauth_2
    OmniAuth.config.test_mode = true
    auth_value = {
      provider: "google_oauth2",
      uid: "99730888979109908",
      info: {
        name: "Jane Smith",
        email: "jane.smith@example.com",
        first_name: "Jane",
        last_name: "Smith",
        image: "https://lh3.googleusercontent.com/photo.png"
      },
      credentials: {
        token: "jbki89u3jio8uoidj9e8uopje89uou93uyi9",
        refresh_token: "ijo9u9i8u8u39u8uhi8f23",
        expires_at: DateTime.now,
        expires: true
      }
    }

    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(auth_value)
    User.create_from_provider_data(auth_value)
  end

  def logout_user_1
    @request.env['devise.mapping'] = Devise.mappings[:user]
    user = stub_omniauth
    sign_out user
  end

  def login_user_2
    @request.env['devise.mapping'] = Devise.mappings[:user]
    user = stub_omniauth_2
    sign_in user
  end
end
