class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :timeoutable,
         :omniauthable, omniauth_providers: [:facebook, :github, :google_oauth2,  :twitter]

  def self.create_from_provider_data(provider_data)
    user = User.where(email: provider_data[:info][:email]).first
    if user
      return user
    else
      where(provider: provider_data[:provider], uid: provider_data[:uid]).first_or_create do | user |
        puts "PROVIDER DATA INFO", provider_data[:info][:name]
        user.email = provider_data[:info][:email]
        user.password = Devise.friendly_token[0, 20]
        user.first_name = provider_data[:info][:first_name] || provider_data[:info][:name].split(' ').first
        user.last_name = provider_data[:info][:last_name] || provider_data[:info][:name].split(' ').last
        user.image = provider_data[:info][:image]
        user.save
      end
    end
  end

  has_many :requests
  has_many :offers
end
