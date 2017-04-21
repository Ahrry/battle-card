FactoryGirl.define do

  factory :card_type do
    name ""
    offensive_objects {}
    defense_objects {}
    level 5
  end

  factory :card_to_play do
    sequence(:name, 1) { |n| "perso#{n}"}
    level 50
    offensive_capacity 5
    defense_capacity 5
    default false
    association :card_type
  end

end
