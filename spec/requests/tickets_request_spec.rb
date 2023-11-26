require 'rails_helper'

RSpec.describe 'Tickets API', type: :request do
  describe 'POST /tickets' do
    let(:valid_attributes) do
      { user_id: 1234, title: 'My title', tags: ['tag1', 'tag2'] }
    end

    context 'when the request is valid' do
      before { post '/tickets', params: valid_attributes }

      it 'creates a ticket' do
        expect(response).to have_http_status(201)
        expect(Ticket.count).to eq(1)
      end

      it 'increments the count for existing tags' do
        tag1 = Tag.find_by(name: 'tag1')
        tag2 = Tag.find_by(name: 'tag2')
        expect(tag1.count).to eq(1)
        expect(tag2.count).to eq(1)
      end

      it 'creates new tags if they do not exist' do
        expect(Tag.count).to eq(2)
      end
    end

    context 'when the request is invalid' do
      before { post '/tickets', params: { user_id: 1234 } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'does not create a ticket' do
        expect(Ticket.count).to eq(0)
      end
    end
  end
end
