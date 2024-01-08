class Ticket < ApplicationRecord
  include Searchable

  STATUSES = [:open, :in_progress, :closed].freeze

  validates :title, presence: true
  validates :description, presence: true

  belongs_to :user

  enum status: STATUSES
end
