require 'rails_helper'

RSpec.describe User, type: :model do

  before(:each) do
  end

  it "it should create an User" do
    nb_user = User.count
    params = { username: "ironman" }
    User.find_or_create(params)
    expect(User.count).to eq(nb_user + 1)
  end

end
