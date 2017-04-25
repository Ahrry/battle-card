require "fight_rules"

RSpec.describe FightRules, type: :lib do

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
