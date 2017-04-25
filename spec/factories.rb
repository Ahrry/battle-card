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

  factory :game do
    sequence(:name, 1) { |n| "game_#{n}"}
  end

  factory :user do
    sequence(:username, 1) { |n| "username_#{n}"}
  end

  factory :game_turn do
    association :game
    association :hand_one
    association :hand_two
  end

end
