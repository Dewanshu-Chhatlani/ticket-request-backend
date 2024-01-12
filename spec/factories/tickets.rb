FactoryBot.define do
  factory :ticket do
    title { Faker::Job.title }
    description { Faker::Lorem.paragraph }
    status { 'open' }
    association :user, factory: :user
  end
end
