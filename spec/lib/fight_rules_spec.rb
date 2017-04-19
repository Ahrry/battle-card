require "fight_rules"
require 'rake'

RSpec.describe FightRules, type: :lib do

  before(:each) do
    CardType.all.destroy
    APP_DEFAULT_CARD_TYPES.each do |card_type|
      params = card_type.last
      FactoryGirl.create :card_type, params
    end
  end

end
