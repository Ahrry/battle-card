require 'fight_rules'

class Hand
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUSES = ["distributed", "played"]
  STATUSES.each do |status|
    self.const_set(status.upcase, status)
    define_method "is_#{status}?" do
      self.status == status
    end
  end

  field :status, default: DISTRIBUTED
  field :remaining_level

  belongs_to :user
  belongs_to :card_to_play
  belongs_to :game

  validates_presence_of :user_id, :card_to_play, :game_id, :status
  validates_inclusion_of :status, in: STATUSES

  before_create :set_default_remaining_level

  def set_default_remaining_level
    return if self.persisted?
    return if self.remaining_level
    self.remaining_level = self.card_to_play.level
  end

  def change_remaining_level!(damage, options={})
    self.remaining_level = FightRules.defend(damage, self.card_to_play, options)
    self.status = Hand::PLAYED
    self.save
  end

end
