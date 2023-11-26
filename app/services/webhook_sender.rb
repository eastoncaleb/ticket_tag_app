class WebhookSender
  include HTTParty

  def self.send_tag_webhook(tag)
    return unless tag

    webhook_url = 'https://webhook.site/be8c40d5-653f-492b-a1b2-86efee0449bd'

    HTTParty.post(
      webhook_url,
      body: { tag: tag.name, count: tag.count }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end
end
