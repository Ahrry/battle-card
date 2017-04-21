require 'rails_helper'

RSpec.describe User, type: :model do

  before(:each) do
  end

  it "it should create an User" do
    nb_user = User.count
    User.create(username: "ironman")
    expect(User.count).to eq(nb_user + 1)
  end

end
