class HandsController < ApplicationController
  before_filter :find_game, only: [:distribute_cards]
  before_filter :find_user, only: [:distribute_cards]

  def distribute_cards
    @game.distribute_cards(@user)
    redirect_to game_path(@game)
  end

  private
  def find_game
    @game = Game.find(params[:game_id])
  end

  def find_user
    @user = User.find(params[:user_id])
  end

end
