require 'rails_helper'

RSpec.describe WebhookSender do
  describe '.send_tag_webhook' do
    let(:tag) { instance_double('Tag', name: 'tag1', count: 1) }

    it 'sends a webhook with the tag' do
      allow(HTTParty).to receive(:post)
      WebhookSender.send_tag_webhook(tag)
      expect(HTTParty).to have_received(:post).with(
        WebhookSender::TAG_URL,
        body: { tag: tag.name, count: tag.count }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end
  end
end
