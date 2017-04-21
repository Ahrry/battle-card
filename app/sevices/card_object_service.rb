module CardObjectService

  self.const_set("OFFENSIVE_CARD_OBJECTS", APP_CARD_OBJECTS["offensive"].keys)
  self.const_set("DEFENSE_CARD_OBJECTS", APP_CARD_OBJECTS["defense"].keys)

  OFFENSIVE_CARD_OBJECTS.each do |card_object|
    self.const_set("OFFENSIVE_#{card_object.upcase}", card_object)
  end

  DEFENSE_CARD_OBJECTS.each do |card_object|
    self.const_set("DEFENSE_#{card_object.upcase}", card_object)
  end

  def remaining_damage(damage, object_name, level)
    case object_name
    when DEFENSE_ARMOR
      remaining_damage_from_armor(damage)
    else
      damage - level
    end
  end

  def remaining_damage_from_armor(damage)
    damage / 2
  end

  self.instance_methods.each do |instance_method|
    module_function instance_method
  end
end
