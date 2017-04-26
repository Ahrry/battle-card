class GamesController < ApplicationController
  before_filter :find_game, only: [:new_user, :show, :add_user]
  before_filter :handle_game_path
  before_filter :set_players, only: [:show]

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
    @hands_of_player_1 = hands_distributed(@player_1) if @player_1
    @hands_of_player_2 = hands_distributed(@player_2) if @player_2
    @selected_card_1 = @game.game_turns.where(status: GameTurn::IN_PROGRESS).first.hand_one.card_to_play
    @selected_card_2 = @game.game_turns.where(status: GameTurn::IN_PROGRESS).first.hand_two.card_to_play
  end

  def add_user
    User.find_or_create({username: params[:username]}, @game)
    if @game.players.count == 2
      redirect_to game_path(@game)
    else
      redirect_to new_user_game_path(@game)
    end
  end

  private
  def game_params
    params.require(:game).permit(:name)
  end

  def find_game
    @game = Game.find(params[:id])
  end

  def set_players
    @game.players_to_user.each_with_index do |user, index|
      instance_variable_set("@player_#{index + 1}", user)
    end
  end

  def hands_distributed(user)
    @game.hands.where(user_id: user.id, status: Hand::DISTRIBUTED)
  end

  def handle_game_path
    if @game
      case @game.players.count
      when 0
        @active = "player_1"
        @path = new_user_game_path(@game)
      when 1
        @active = "player_2"
        @path = new_user_game_path(@game)
      when 2
        @active = "lets_go"
        @path = game_path(@game)
      end
    else
      @active = "game"
      @path = new_game_path
    end
  end

end
