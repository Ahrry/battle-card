class CardType
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :offensive_objects, type: Hash, default: {} # example { force: 5 }
  field :defense_objects, type: Hash, default: {} # example { magic_shield: 0.5 }
  field :level, type: Integer, default: 1

  has_many :cards

  validates_presence_of :name, :level
  validates_uniqueness_of :name
  validates_inclusion_of :level, in: 0..10
  validates_inclusion_of :name, in: APP_DEFAULT_CARD_TYPES.keys
end
