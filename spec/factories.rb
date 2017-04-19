FactoryGirl.define do

  factory :card_type do
    name ""
    offensive_objects {}
    defense_objects {}
    level 5
  end

  factory :card do
    sequence(:title, 1) { |n| "MyEvent#{n}"}
    name ""
    level 50
    offensive_capacity 5
    defense_capacity 5
    default false
    association :card_type
  end

end
