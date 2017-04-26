class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username, type: String

  validates_presence_of :username
  validates_uniqueness_of :username

  def self.find_or_create_user(username, game = nil)
    user = User.where(username: username).first
    user = User.create(username: username) unless user
    game.players << user if game
  end

end
