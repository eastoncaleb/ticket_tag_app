class TicketsController < ApplicationController
  def create
    ticket = Ticket.new(ticket_params)
    response_message, status_code = nil, nil

    Ticket.transaction do
      if tags_count_exceeded?
        response_message, status_code = { error: 'can not have more than 5 tags' }, :unprocessable_entity
      elsif ticket.save
        handle_tags(ticket)
        send_tag_webhook
        response_message, status_code = { message: 'Ticket created successfully.' }, :created
      else
        errors = ticket.errors.full_messages.to_sentence || 'invalid parameters'
        response_message, status_code = { error: ticket.errors.full_messages.to_sentence }, :unprocessable_entity
      end
    end

    render json: response_message, status: status_code
  end

  private

  def ticket_params
    params.permit(:user_id, :title)
  end

  def tags
    @tags ||= params[:tags] ? params[:tags].map(&:downcase) : []
  end

  def handle_tags(ticket)
    return unless tags.present? && !tags_count_exceeded?

    assign_tags(ticket)
    increment_tags_count(ticket)
  end

  def assign_tags(ticket)
    existing_tags = Tag.where(name: tags).index_by(&:name)
    tags.each do |tag_name|
      tag = existing_tags[tag_name] || Tag.create(name: tag_name)
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

  def tags_count_exceeded?
    tags.count > 5
  end
end
