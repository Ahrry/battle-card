class GameTurnsController < ApplicationController
  before_filter :find_game, only: [:create, :battle]
  before_filter :find_game_turn, only: [:battle]

  def create
    @game_turn = @game.game_turns.build(game_turn_params)
    messsage = @game_turn.errors.full_messages unless @game_turn.save
    redirect_to game_path(@game), alert: messsage
  end

  def battle
    @game_turn.battle!
    redirect_to game_path(@game)
  end

  private
  def game_turn_params
    params.require(:game_turn).permit(:hand_one_id, :hand_two_id)
  end

  def find_game_turn
    @game_turn = @game.game_turns.find(params[:id])
  end

  def find_game
    @game = Game.find(params[:game_id])
  end

end
