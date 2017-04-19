module FightRules
  module_function

  def fight
  end

  def attack(card)
    case card.card_type.name
    when CardType::JEDI
      jedi_attack(card)
    when CardType::DROID
      droid_attack(card)
    when CardType::PILOT
      pilot_attack(card)
    else
      default_attack(card)
    end
  end

  def protect(damage, card, options={})
  end

  def default_attack(card)
    (card.offensive_capacity / 10) * card.level
  end

  def jedi_attack(card)
    card_type = card.card_type
    return unless card_type.is_jedi?
    damage = default_attack(card)
    damage + (card_type.level / 10) * card_type.offensive_objects.values.sample
  end

  def droid_attack(card)
    card_type = card.card_type
    return unless card_type.is_droid?
    damage = (card.offensive_capacity / card.defense_capacity) * card.level
    card_type = card.card_type
    card_type.offensive_objects.values.each do |value|
      damage += value
    end
    damage + card_type.level
  end

  def pilot_attack(card)
    card_type = card.card_type
    return unless card_type.is_pilot?
    damage = default_attack(card)
    card_type.offensive_objects.values.each do |value|
      damage += (card_type.level / 10) * value
    end
    damage
  end

end
