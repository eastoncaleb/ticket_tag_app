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

    context 'when too many tags are provided' do
      before { post '/tickets', params: { user_id: 1234, title: 'My title', tags: ['tag1', 'tag2', 'tag3', 'tag4', 'tag5', 'tag6'] } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'does not create a ticket or tags' do
        expect(Ticket.count).to eq(0)
        expect(Tag.count).to eq(0)
      end

      it 'returns an error message about too many tags' do
        expect(JSON.parse(response.body)['error']).to eq('can not have more than 5 tags')
      end
    end

    context 'when there is a failure during ticket creation' do
      before do
        allow_any_instance_of(Ticket).to receive(:save).and_return(false)
        post '/tickets', params: valid_attributes
      end

      it 'rolls back the entire transaction' do
        expect(response).to have_http_status(422)
        expect(Ticket.count).to eq(0)
        # Assuming tags are only created if ticket saves successfully
        expect(Tag.count).to eq(0)
      end
    end
  end
end
