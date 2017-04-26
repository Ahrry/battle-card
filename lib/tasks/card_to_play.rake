namespace :card_to_play do

  task :generate_default_card => :environment do
    number_of_default_cards = APP_DEFAULT_CARD_TO_PLAYS.count
    number_of_default_created_cards = 0
    APP_DEFAULT_CARD_TO_PLAYS.each do |card|
      params = card.last.merge!(default: true)
      card_type = CardType.find_by_name(params.delete("type"))
      if card_type
        card_to_play = card_type.card_to_plays.new(params)
        if card_to_play.save
          number_of_default_created_cards += 1
        else
          puts "Not save! Card #{params["name"]} with params #{params}, errors => #{card_to_play.errors.full_messages}"
        end
      else
        puts "Error! Card type #{params["name"]} does not exist"
      end
    end
    puts "**** #{number_of_default_created_cards} / #{number_of_default_cards} default cards has been created ****"
  end
  
end
