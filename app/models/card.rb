class Card
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :level, type: Integer, default: 50
  field :offensive_capacity, type: Integer, default: 5
  field :defense_capacity, type: Integer, default: 5
  field :default, type: Boolean, default: false

  belongs_to :card_type

  validates_presence_of :name, :level, :offensive_capacity, :defense_capacity
  validates_inclusion_of :level, in: 1..100
  validates_inclusion_of :offensive_capacity, in: 1..10
  validates_inclusion_of :defense_capacity, in: 1..10
end
