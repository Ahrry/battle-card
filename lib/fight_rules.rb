module FightRules
  module_function

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

  def defend(damage, card, options={})
    have_defense_objects = card.card_type.have_defense_objects?
    have_same_card_type = card.card_type.name == options[:type_name]

    return damage if !have_same_card_type && !have_defense_objects

    remaining_damage = damage

    if have_defense_objects
      remaining_damage = 0
      defense_objects = card.card_type.defense_objects
      defense_keys = defense_objects.keys
      defense_keys.each do |key|
        remaining_damage += CardObjectService.remaining_damage(damage, key, defense_objects[key])
      end
      # Need if you have many defense objects (average of remaining damage)
      remaining_damage = remaining_damage / defense_keys.count
    end

    if have_same_card_type
      remaining_damage =remaining_damage * 0.8
    end

    return remaining_damage
  end

  def default_attack(card)
    (card.offensive_capacity.round(2) / 10) * card.level
  end

  def jedi_attack(card)
    card_type = card.card_type
    return unless card_type.is_jedi?
    damage = default_attack(card)
    damage += (card_type.level.round(2) / 10) * card_type.offensive_objects.values.sample
    damage.round
  end

  def droid_attack(card)
    card_type = card.card_type
    return unless card_type.is_droid?
    damage = (card.offensive_capacity.round(2) / card.defense_capacity.round(2)) * card.level
    card_type = card.card_type
    card_type.offensive_objects.values.each do |value|
      damage += value
    end
    damage += card_type.level
    damage.round
  end

  def pilot_attack(card)
    card_type = card.card_type
    return unless card_type.is_pilot?
    damage = default_attack(card)
    card_type.offensive_objects.values.each do |value|
      damage += (card_type.level.round(2) / 10) * value
    end
    damage.round
  end

end
