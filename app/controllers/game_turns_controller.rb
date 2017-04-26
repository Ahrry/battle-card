class GameTurnsController < ApplicationController

  before_filter :find_game, only: [:create]

  def create
    @game_turn = @game.game_turns.build(game_turn_params)
    messsage = @game_turn.errors.full_messages unless @game_turn.save
    redirect_to game_path(@game), alert: messsage
  end

  private
  def game_turn_params
    params.require(:game_turn).permit(:hand_one_id, :hand_two_id)
  end

  def find_game
    @game = Game.find(params[:game_id])
  end

end
