require 'rails_helper'

RSpec.describe Game, type: :model do

  before(:each) do
    APP_DEFAULT_CARD_TYPES.each do |card_type|
      params = card_type.last.clone
      offensive_objects = params.delete("offensive_objects")
      defense_objects = params.delete("defense_objects")
      params.merge!({
        offensive_objects: CardType.build_objects(offensive_objects, "offensive"),
        defense_objects: CardType.build_objects(defense_objects, "defense")
      })
      FactoryGirl.create :card_type, params
    end

    APP_DEFAULT_CARD_TO_PLAYS.each_with_index do |card_to_play, index|
      params = card_to_play.last.clone
      card_type = CardType.find_by_name(params.delete("type"))
      card_to_play = FactoryGirl.create :card_to_play, card_type: card_type, name: params["name"], level: params["level"], offensive_capacity: params["offensive_capacity"], defense_capacity: params["defense_capacity"]
      instance_variable_set("@card_#{index + 1}", card_to_play)
    end

    @user_1 = FactoryGirl.create :user
    @user_2 = FactoryGirl.create :user
    @game = FactoryGirl.create :game
  end

  it "should PLAY a full game and RETURN the WINNER", focus: true do
    # distributes cards to users
    @deck_1 = @game.distribute_cards(@user_1)
    @deck_2 = @game.distribute_cards(@user_2)

    # check only two cards by users
    expect(@deck_1.count).to eq(2)
    expect(@deck_2.count).to eq(2)

    # check default remaining level equal to card level
    expect(@deck_1.first.remaining_level).to eq(@deck_1.first.card_to_play.level)
    expect(@deck_1.last.remaining_level).to eq(@deck_1.last.card_to_play.level)
    expect(@deck_2.first.remaining_level).to eq(@deck_2.first.card_to_play.level)
    expect(@deck_2.last.remaining_level).to eq(@deck_2.last.card_to_play.level)

    # check status hand has been distributed
    expect(@deck_1.first.status).to eq(Hand::DISTRIBUTED)
    expect(@deck_1.last.status).to eq(Hand::DISTRIBUTED)
    expect(@deck_2.first.status).to eq(Hand::DISTRIBUTED)
    expect(@deck_2.last.status).to eq(Hand::DISTRIBUTED)

    # play first turn
    @first_turn = FactoryGirl.create :game_turn, game: @game, hand_one: @deck_1.first, hand_two: @deck_2.first
    expect(@first_turn.winner).to be_nil
    expect(@first_turn.status).to eq(GameTurn::IN_PROGRESS)

    @first_turn.battle!
    @first_turn.equal? ? expect(@first_turn.winner).to(be_nil) : expect(@first_turn.winner).not_to(be_nil)
    expect(@first_turn.status).to eq(GameTurn::TERMINATED)
    expect(@first_turn.hand_one.status).to eq(Hand::PLAYED)
    expect(@first_turn.hand_two.status).to eq(Hand::PLAYED)

    # play last turn
    @last_turn = FactoryGirl.create :game_turn, game: @game, hand_one: @deck_1.last, hand_two: @deck_2.last
    expect(@last_turn.winner).to be_nil
    expect(@last_turn.status).to eq(GameTurn::IN_PROGRESS)

    @last_turn.battle!
    @last_turn.equal? ? expect(@last_turn.winner).to(be_nil) : expect(@last_turn.winner).not_to(be_nil)
    expect(@last_turn.status).to eq(GameTurn::TERMINATED)
    expect(@last_turn.hand_one.status).to eq(Hand::PLAYED)
    expect(@last_turn.hand_two.status).to eq(Hand::PLAYED)

    # return winner of game
    @game.winner
  end

end
