class TicketsController < ApplicationController
  def create
    ticket = Ticket.new(ticket_params)
    assign_tags(ticket) if tags.present?

    if ticket.save
      increment_tags_count(ticket) if tags.present?
      send_tag_webhook
      render json: { message: 'Ticket created successfully.' }, status: :created
    else
      errors = ticket.errors.full_messages.to_sentence || 'invalid parameters'
      render json: { error: errors }, status: :unprocessable_entity
    end
  end

  private

  def ticket_params
    params.permit(:user_id, :title)
  end

  def tags
    @tags ||= params[:tags] ? params[:tags].map(&:downcase) : []
  end

  def assign_tags(ticket)
    tags.each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name)
      ticket.tags << tag unless ticket.tags.include?(tag)
    end
  end

  def increment_tags_count(ticket)
    ticket.tags.each do |tag|
      tag.increment!(:count)
    end
  end

  def send_tag_webhook
    highest_count_tag = Tag.highest_count_tag
    WebhookSender.send_tag_webhook(highest_count_tag)
  end
end
