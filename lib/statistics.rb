module Statistics
  module_function

  def ranking_of_game(game_id)
    match = { "$match" => match_params(game_id) }
    group = { "$group" => { _id: "$winner_id", count: { "$sum" => 1 } } }
    sort = { "$sort" => { count: -1 } }
    pipeline = [match, group, sort]
    GameTurn.collection.aggregate(pipeline).to_a
  end

  def match_params(game_id)
    { game_id: game_id, status: GameTurn::TERMINATED, winner_id: { "$ne" => nil } }
  end

end
