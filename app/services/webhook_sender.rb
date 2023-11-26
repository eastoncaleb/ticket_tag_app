class WebhookSender
  include HTTParty
  TAG_URL = 'https://webhook.site/be8c40d5-653f-492b-a1b2-86efee0449bd'.freeze

  def self.send_tag_webhook(tag)
    return unless tag

    HTTParty.post(
      TAG_URL,
      body: { tag: tag.name, count: tag.count }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end
end
