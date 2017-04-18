class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username, type: String

  validates_presence_of :username
  validates_uniqueness_of :username
end
