require "statistics"

RSpec.describe Statistics, type: :lib do

  before(:each) do
    user_1 = FactoryGirl.create :user
    user_2 = FactoryGirl.create :user
    @game = FactoryGirl.create :game

    deck_1 = @game.distribute_cards(user_1)
    deck_2 = @game.distribute_cards(user_2)

    game_turn = FactoryGirl.create :game_turn, game: @game, hand_one: deck_1[0], hand_two: deck_2[0]
    game_turn.battle!
    game_turn = FactoryGirl.create :game_turn, game: @game, hand_one: deck_1[1], hand_two: deck_2[1]
    game_turn.battle!
    game_turn = FactoryGirl.create :game_turn, game: @game, hand_one: deck_1[2], hand_two: deck_2[2]
    game_turn.battle!
  end

  it "should RETURN always only ONE or TWO result" do
    result = Statistics.ranking_of_game(@game.id)
    expect([1,2]).to include(result.count)
  end

end
