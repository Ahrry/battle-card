class GamesController < ApplicationController
  before_filter :find_game, only: [:show]
  before_filter :handle_active

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to game_path(@game)
    else
      render :new
    end
  end

  def show
  end

  private
  def game_params
    params.require(:game).permit(:name)
  end

  def find_game
    @game = Game.find(params[:id])
  end

  def handle_active
    if @game
      case @game.hands.count
      when 0
        @active = "player_1"
      when Game::NUMBER_OF_CARDS_BY_DECK
        @active = "player_2"
      when Game::NUMBER_OF_CARDS_BY_DECK * 2
        @active = "lets_go"
      end
    else
      @active = "game"
    end
  end

end
