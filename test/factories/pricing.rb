require_relative '../../app/models/vendor/pricing'

FactoryGirl.define do
  factory :pricing do
    model 'fixed'
    period 'monthly'
  end
end