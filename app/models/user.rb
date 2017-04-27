class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username, type: String

  validates_presence_of :username
  validates_uniqueness_of :username

  def self.find_or_create(params, game = nil)
    user = User.find_or_create_by(username: params[:username])
    if game
      game.players << user.id
      game.players.delete(user.id) unless game.save
    end
    user
  end

end
