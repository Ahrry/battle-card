require "fight_rules"
require 'rake'

RSpec.describe FightRules, type: :lib do

  before(:each) do
    CardType.all.destroy
    APP_DEFAULT_CARD_TYPES.each do |card_type|
      params = card_type.last
      FactoryGirl.create :card_type, params
    end

    Card.all.destroy
    card_type = CardType.first
    debugger
    @card1 = FactoryGirl.create :card, card_type: card_type, level: 89, offensive_capacity: 7, defense_capacity: 5
  end

  it "hello", focus: true do
    debugger
    puts "hello"
  end

end
