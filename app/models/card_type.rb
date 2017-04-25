class CardType
  include Mongoid::Document
  include Mongoid::Timestamps

  include Finder

  self.const_set("TYPES", APP_DEFAULT_CARD_TYPES.keys)
  TYPES.each do |type|
    self.const_set(type.upcase, type)
    define_method "is_#{type}?" do
      self.name == type
    end
  end

  field :name, type: String
  field :offensive_objects, type: Hash, default: {} # example { force: 5, lightsaber: 10 }
  field :defense_objects, type: Hash, default: {} # example { magic_shield: 2 }
  field :level, type: Integer, default: 1

  has_many :card_to_plays, dependent: :destroy

  validates_presence_of :name, :level
  validates_uniqueness_of :name
  validates_inclusion_of :level, in: 0..10
  validates_inclusion_of :name, in: TYPES

  def have_defense_objects?
    defense_objects.count > 0
  end

  def self.build_objects(array, type)
    result = {}
    array.each do |value|
      result.merge!({ value.to_sym => APP_CARD_OBJECTS[type][value] })
    end
    result
  end
end
