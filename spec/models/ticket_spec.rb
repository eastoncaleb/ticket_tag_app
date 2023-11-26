require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(Ticket.new(user_id: 123, title: 'Example Title')).to be_valid
    end

    it 'is not valid without a user_id' do
      ticket = Ticket.new(user_id: nil, title: 'Example Title')
      expect(ticket).not_to be_valid
    end

    it 'is not valid without a title' do
      ticket = Ticket.new(user_id: 123, title: nil)
      expect(ticket).not_to be_valid
    end

    it 'is valid with five or fewer tags' do
      ticket = Ticket.new(user_id: 123, title: 'Example Title')
      5.times { ticket.tags.build(name: "tag#{rand(1000)}") }
      expect(ticket).to be_valid
    end

    it 'is not valid with more than five tags' do
      ticket = Ticket.new(user_id: 123, title: 'Example Title')
      6.times { ticket.tags.build(name: "tag#{rand(1000)}") }
      expect(ticket).not_to be_valid
      expect(ticket.errors[:tags]).to include('can not have more than 5 tags')
    end
  end
end
