require "fight_rules"

RSpec.describe FightRules, type: :lib do

  before(:each) do
    APP_DEFAULT_CARD_TYPES.each do |card_type|
      params = card_type.last.clone
      offensive_objects = params.delete("offensive_objects")
      defense_objects = params.delete("defense_objects")
      params.merge!({
        offensive_objects: CardType.build_objects(offensive_objects, "offensive"),
        defense_objects: CardType.build_objects(defense_objects, "defense")
      })
      FactoryGirl.create :card_type, params
    end

    APP_DEFAULT_CARD_TO_PLAYS.each_with_index do |card_to_play, index|
      params = card_to_play.last.clone
      card_type = CardType.find_by_name(params.delete("type"))
      card_to_play = FactoryGirl.create :card_to_play, card_type: card_type, name: params["name"], level: params["level"], offensive_capacity: params["offensive_capacity"], defense_capacity: params["defense_capacity"]
      instance_variable_set("@card_#{index + 1}", card_to_play)
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

  it "should RETURN DAMAGE of specific card AFTER ATTACK" do
    damage = FightRules.attack(@card_1)
    expect([86, 87]).to include(damage)

    damage = FightRules.attack(@card_2)
    expect([68, 69]).to include(damage)

    damage = FightRules.attack(@card_3)
    expect(damage).to eq(42)

    damage = FightRules.attack(@card_4)
    expect(damage).to eq(85)
  end

  it "should RETURN REMAINING DAMAGE of specific card AFTER DEFENSE" do
    damage = FightRules.attack(@card_2)
    expect([68, 69]).to include(damage)
    options = { type_name: @card_2.card_type.name }
    remaining_damage  = FightRules.defend(damage, @card_3, options)
    expect(remaining_damage).to be < damage
  end

end
