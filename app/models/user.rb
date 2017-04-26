class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username, type: String

  validates_presence_of :username
  validates_uniqueness_of :username

  def self.find_or_create(params, game = nil)
    user = User.where(username: params[:username]).first
    user = User.create(params) unless user
    if game
      game.players << user.id
      game.players.delete(user.id) unless game.save
    end
    user
  end

end
