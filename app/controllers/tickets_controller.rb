class TicketsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    ticket = Ticket.create(ticket_params)
    if ticket.persisted?
      add_tags(ticket)
      render json: { message: 'Ticket created successfully.' }, status: :created
    else
      errors = ticket.errors || 'invalid parameters'
      render json: { error: errors }, status: :unprocessable_entity
    end
  end

  private

  def ticket_params
    params.permit(:user_id, :title, :tags)
  end

  def add_tags(ticket)
    return unless params[:tags].present?

    params[:tags].each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name.downcase)
      ticket.tags << tag unless ticket.tags.include?(tag)
      tag.increment!(:count)
    end
  end

  # implement this
  def send_tag_webhook
  end
end
