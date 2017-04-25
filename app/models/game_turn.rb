require 'fight_rules'

class GameTurn
  include Mongoid::Document
  include Mongoid::Timestamps

  # TODO factorize STATUSES with concern HasStatuses
  STATUSES = ["in_progress", "terminated"]
  STATUSES.each do |status|
    self.const_set(status.upcase, status)
    define_method "is_#{status}?" do
      self.status == status
    end
  end

  field :status, default: IN_PROGRESS

  belongs_to :game
  belongs_to :hand_one, class_name: "Hand", foreign_key: :hand_1_id
  belongs_to :hand_two, class_name: "Hand", foreign_key: :hand_2_id
  belongs_to :winner, class_name: "User", foreign_key: :winner_id

  validates_presence_of :game_id, :hand_1_id, :hand_2_id
  validates_inclusion_of :status, in: STATUSES

  def battle!
    card_one = hand_one.card_to_play
    damage = FightRules.attack(card_one)
    option = { type_name: card_one.card_type.name }
    hand_two.change_remaining_level!(damage, option)

    card_two = hand_two.card_to_play
    damage = FightRules.attack(card_two)
    option = { type_name: card_two.card_type.name }
    hand_one.change_remaining_level!(damage, option)

    self.status = TERMINATED
    self.winner = self.hand_two.user if self.hand_two.remaining_level > self.hand_one.remaining_level
    self.winner = self.hand_one.user if self.hand_one.remaining_level > self.hand_two.remaining_level
    self.save
  end

  def equal?
    self.status == TERMINATED && !self.winner
  end

end
