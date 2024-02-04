class TicketsController < ApplicationController
  load_and_authorize_resource
  before_action :set_ticket, only: [:update, :clone, :destroy]

  def index
    if current_user.admin?
      tickets = Ticket.search(search_params)
    else
      tickets = Ticket.search(search_params, current_user.id)
    end

    render json: tickets
  end

  def create
    ticket = Ticket.new(ticket_params)
    ticket.user = current_user

    if ticket.save
      render json: ticket, status: :created
    else
      render json: {error: ticket.errors.full_messages.to_sentence}, status: :bad_request
    end
  end

  def update
    if @ticket && @ticket.update(ticket_params)
      render json: @ticket
    else
      render json: {error: @ticket.errors.full_messages.to_sentence}, status: :bad_request
    end
  end

  def clone
    if current_user.admin?
      ticket = @ticket.dup
      ticket.user = current_user

      if ticket.save
        render json: ticket, status: :created
      else
        render json: {error: ticket.errors.full_messages.to_sentence}, status: :bad_request
      end
    else
      render json: {error: 'You do not have access to this operation!'}, status: :unauthorized
    end
  end

  def destroy
    if !@ticket || !@ticket.destroy
      render json: {error: ticket.errors.full_messages.to_sentence}, status: :bad_request
    end
  end

  private

  def search_params
    params.permit(:query, :page, :per_page, :sort_by, :sort_order)
  end

  def ticket_params
    params.permit(:title, :description, :status)
  end

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end
end
