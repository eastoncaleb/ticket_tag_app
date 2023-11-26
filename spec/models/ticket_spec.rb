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
  end
end
