require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it "is valid with valid attributes" do
    ticket = FactoryBot.build(:ticket)
    expect(ticket).to be_valid
  end

  it "is not valid without a title" do
    ticket = FactoryBot.build(:ticket, title: nil)
    expect(ticket).to_not be_valid
  end

  it "is not valid without a description" do
    ticket = FactoryBot.build(:ticket, description: nil)
    expect(ticket).to_not be_valid
  end
end
