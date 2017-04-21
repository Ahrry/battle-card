require "fight_rules"

RSpec.describe FightRules, type: :lib do

  before(:each) do
    APP_DEFAULT_CARD_TYPES.each do |card_type|
      params = card_type.last
      FactoryGirl.create :card_type, params
    end

    APP_DEFAULT_CARD_TO_PLAYS.each do |card_to_play|
      params = card_to_play.last.clone
      card_type = CardType.find_by_name(params.delete("type"))
      FactoryGirl.create :card_to_play, card_type: card_type, name: params["name"], level: params["level"], offensive_capacity: params["offensive_capacity"], defense_capacity: params["defense_capacity"]
    end
  end

  it "should return ONLY DAMAGE of JEDI" do
    card_type = CardType.find_by_name(CardType::JEDI)
    card = card_type.card_to_plays.first
    damage = FightRules.jedi_attack(card)
    expect(damage).not_to be_nil
    expect([86, 87]).to include(damage)
  end

  it "should return ONLY DAMAGE of DROID" do
    card_type = CardType.find_by_name(CardType::DROID)
    card = card_type.card_to_plays.first
    damage = FightRules.droid_attack(card)
    expect(damage).not_to be_nil
    expect(damage).to eq(42)
  end

  it "should return ONLY DAMAGE of PILOT" do
    card_type = CardType.find_by_name(CardType::PILOT)
    card = card_type.card_to_plays.first
    damage = FightRules.pilot_attack(card)
    expect(damage).not_to be_nil
    expect(damage).to eq(85)
  end

  it "should NOT return DAMAGE" do
    card_type = CardType.find_by_name(CardType::PILOT)
    card = card_type.card_to_plays.first
    damage = FightRules.jedi_attack(card)
    expect(damage).to be_nil
    damage = FightRules.droid_attack(card)
    expect(damage).to be_nil
    card_type = CardType.find_by_name(CardType::DROID)
    card = card_type.card_to_plays.first
    damage = FightRules.pilot_attack(card)
    expect(damage).to be_nil
  end

end
