# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can :manage, :all if user.admin?
    can :manage, Ticket, user: user if user.customer?
  end
end
