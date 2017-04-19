namespace :card_type do

  task :generate_card_types => :environment do
    number_of_card_types = APP_DEFAULT_CARD_TYPES.count
    number_of_card_type_created = 0
    APP_DEFAULT_CARD_TYPES.each do |card_type|
      params = card_type.last
      type = CardType.new(params)
      if type.save
        number_of_card_type_created += 1
      else
        puts "Not save! #{params.name} => #{type.errors.full_messages}"
      end
    end
    puts "#{number_of_card_type_created} / #{number_of_card_types} card types created"
  end

  task :create_or_update_default_card_type => :environment do
    # TODO
  end

end
