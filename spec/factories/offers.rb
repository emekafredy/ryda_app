FactoryBot.define do
  factory :offer do
    origin "Jibowu"
    destination "Epic Tower"
    take_off '2019-06-08 12:00:00'
    maximum_intake 3

    factory :completed_offers do
      origin { Faker::Address.street_name }
      destination { Faker::Address.street_name }
      take_off '2019-06-08 12:00:00'
      maximum_intake 3
      status 3
    end

    factory :available_rides do
      origin { Faker::Address.street_name }
      destination { Faker::Address.street_name }
      take_off { Faker::Date.forward(2) }
      maximum_intake 5
    end

    factory :matching_offer do
      origin "Ikeja"
      destination "Epic Tower"
      take_off (Time.now + 10*60*60).strftime("%F %T")
      maximum_intake 5
    end
  end
end
