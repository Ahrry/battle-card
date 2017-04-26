class GamesController < ApplicationController
  before_filter :find_game

  def create
    User.find_or_create_user(params[:username], @game)
  end

  private
  def find_game
    return unless params[:game_id]
    @game = Game.find(params[:game_id])
  end

end
