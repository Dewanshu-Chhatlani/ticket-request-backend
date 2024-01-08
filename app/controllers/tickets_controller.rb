class TicketsController < ApplicationController
  before_action :set_ticket, only: [:update, :clone, :destroy]

  def index
    if logged_in_user.admin
      tickets = Ticket.search(search_params)
    else
      tickets = Ticket.search(search_params, logged_in_user.id)
    end

    render json: tickets
  end

  def create
    ticket = Ticket.new(ticket_params)
    ticket.user = logged_in_user

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
    if logged_in_user.admin
      ticket = @ticket.dup
      ticket.user = logged_in_user

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
    if logged_in_user.admin
      @ticket = Ticket.find(params[:id])
    else
      @ticket = logged_in_user.tickets.find(params[:id])
    end
  end
end
