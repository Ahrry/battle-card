namespace :card do

  task :generate_default_card => :environment do
    number_of_default_cards = APP_DEFAULT_CARDS.count
    number_of_default_created_cards = 0
    APP_DEFAULT_CARDS.each do |card|
      params = card.last.merge!(default: true)
      card_type = CardType.find_by_name(params.delete("type"))
      if card_type
        card = card_type.cards.new(params)
        if card.save
          number_of_default_created_cards += 1
        else
          puts "Not save! Card #{params[name]} with params #{params}, errors => #{card.errors.full_messages}"
        end
      else
        puts "Error! Card type #{params[name]} does not exist"
      end
    end
    puts "**** #{number_of_default_created_cards} / #{number_of_default_cards} default cards has been created ****"
  end

end
