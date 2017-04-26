require 'rails_helper'

RSpec.describe Game, type: :model do

  before(:each) do
    @game = FactoryGirl.create :game
    @user_1 = User.find_or_create({ username: "user_1" }, @game)
    @user_2 = User.find_or_create({ username: "user_2" }, @game)
  end

  it "should PLAY a full game and RETURN the WINNER" do
    # distributes cards to users
    deck_1 = @game.distribute_cards(@user_1)
    deck_2 = @game.distribute_cards(@user_2)

    # check only five cards by users
    expect(deck_1.count).to eq(3)
    expect(deck_2.count).to eq(3)

    # check default remaining level equal to card level
    expect(deck_1.first.remaining_level).to eq(deck_1.first.card_to_play.level)
    expect(deck_1.last.remaining_level).to eq(deck_1.last.card_to_play.level)
    expect(deck_2.first.remaining_level).to eq(deck_2.first.card_to_play.level)
    expect(deck_2.last.remaining_level).to eq(deck_2.last.card_to_play.level)

    # check status hand has been distributed
    expect(deck_1.first.status).to eq(Hand::DISTRIBUTED)
    expect(deck_1.last.status).to eq(Hand::DISTRIBUTED)
    expect(deck_2.first.status).to eq(Hand::DISTRIBUTED)
    expect(deck_2.last.status).to eq(Hand::DISTRIBUTED)

    # play first turn and check states
    game_turn = FactoryGirl.build :game_turn, game: @game, hand_one: deck_1[0], hand_two: deck_2[0]
    game_turn.save
    expect(game_turn.winner).to be_nil
    expect(game_turn.status).to eq(GameTurn::IN_PROGRESS)

    # check status hand has been changed to played
    expect(game_turn.hand_one.reload.status).to eq(Hand::PLAYED)
    expect(game_turn.hand_two.reload.status).to eq(Hand::PLAYED)

    game_turn.battle!
    game_turn.equal? ? expect(game_turn.winner).to(be_nil) : expect(game_turn.winner).not_to(be_nil)
    expect(game_turn.status).to eq(GameTurn::TERMINATED)
    expect(game_turn.hand_one.status).to eq(Hand::PLAYED)
    expect(game_turn.hand_two.status).to eq(Hand::PLAYED)

    # play second turn
    game_turn = FactoryGirl.create :game_turn, game: @game, hand_one: deck_1[1], hand_two: deck_2[1]
    game_turn.battle!

    # play last turn
    game_turn = FactoryGirl.create :game_turn, game: @game, hand_one: deck_1[2], hand_two: deck_2[2]
    game_turn.battle!

    # return winner of game (nil for equal)
    winner = @game.winner
    winner = winner.class if winner
    expect([nil, User]).to include(winner)
  end

  it "it should add maximum Game::NUMBER_OF_PLAYERS players in game" do
    game = FactoryGirl.create :game
    expect(game.players.count).to eq(0)
    User.find_or_create({ username: "ironman" }, game)
    User.find_or_create({ username: "batman" }, game)
    User.find_or_create({ username: "spiderman" }, game)
    expect(game.players.count).to eq(Game::NUMBER_OF_PLAYERS)
    expect(game.valid?).to eq(true)
    expect(game.persisted?).to eq(true)
  end

end
