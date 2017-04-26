class GamesController < ApplicationController
  before_filter :find_game, only: [:new_user, :show]
  before_filter :handle_game_path

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to new_user_game_path(@game)
    else
      render :new
    end
  end

  def new_user
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

  def handle_game_path
    if @game
      case @game.hands.count
      when 0
        @active = "player_1"
        @path = new_user_game_path(@game)
      when Game::NUMBER_OF_CARDS_BY_DECK
        @active = "player_2"
        @path = new_user_game_path(@game)
      when Game::NUMBER_OF_CARDS_BY_DECK * 2
        @active = "lets_go"
        @path = game_path(@game)
      end
    else
      @active = "game"
      @path = new_game_path
    end
  end

end
