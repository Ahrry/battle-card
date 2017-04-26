module ApplicationHelper

  def handle_game_path(game)
    game.persisted? ? game_path(game) : new_game_path
  end

end
