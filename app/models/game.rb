require 'statistics'

class Game
  include Mongoid::Document
  include Mongoid::Timestamps

  NUMBER_OF_CARDS_BY_DECK = 3
  NUMBER_OF_PLAYERS = 2

  field :name, type: String
  field :players, type: Array, default: []

  has_many :game_turns
  has_many :hands

  validates_presence_of :name

  def distribute_cards(user)
    return unless CardToPlay.first
    deck = []
    NUMBER_OF_CARDS_BY_DECK.times do
      # TODO random card should be improved
      hand = self.hands.build(user_id: user.id, card_to_play_id: CardToPlay.all.sample.id)
      deck << hand if hand.save
    end
    deck
  end

  def winner
    ranking = Statistics.ranking_of_game(self.id)
    return unless ranking
    return if ranking[1] && ranking[1]["_id"] == ranking[0]["_id"]
    return User.find(ranking[0]["_id"])
  end

  def check_number_of_player
    if self.players.count > NUMBER_OF_PLAYERS
      errors.add(:players, "")
    end
  end

end
