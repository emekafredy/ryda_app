class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :timeoutable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def self.create_from_provider_data(provider_data)
    where(provider: provider_data[:provider], uid: provider_data[:uid]).first_or_create do | user |
      user.email = provider_data[:info][:email]
      user.password = Devise.friendly_token[0, 20]
      user.first_name = provider_data[:info][:first_name]
      user.last_name = provider_data[:info][:last_name]
      user.image = provider_data[:info][:image]
      user.save
    end
  end

  has_many :requests
  has_many :offers
end
