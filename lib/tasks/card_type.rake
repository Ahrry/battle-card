namespace :card_type do

  task :generate_card_types => :environment do
    number_of_card_types = APP_DEFAULT_CARD_TYPES.count
    number_of_created_card_types = 0
    APP_DEFAULT_CARD_TYPES.each do |card_type|
      params = card_type.last
      offensive_objects = params.delete("offensive_objects")
      defense_objects = params.delete("defense_objects")
      params.merge!({
        offensive_objects: CardType.build_objects(offensive_objects, "offensive"),
        defense_objects: CardType.build_objects(defense_objects, "defense")
      })
      type = CardType.new(params)
      if type.save
        number_of_created_card_types += 1
      else
        puts "Not save! #{params["name"]} => #{type.errors.full_messages}"
      end
    end
    puts "**** #{number_of_created_card_types} / #{number_of_card_types} card types has been created ****"
  end

  task :create_or_update_default_card_type => :environment do
    # TODO
  end

end
