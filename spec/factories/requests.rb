FactoryBot.define do
  factory :request do
    origin "Jibowu"
    destination "Epic Tower"
    take_off '2019-06-08 12:00:00'

    factory :matching_request do
      origin "Ikeja"
      destination "Epic Tower"
      take_off (Time.now + 10*60*60).strftime("%F %T")
    end

    factory :booked_request do
      origin "Ikeja"
      destination "Epic Tower"
      take_off (Time.now + 10*60*60).strftime("%F %T")
      status 1
    end
  end
end
