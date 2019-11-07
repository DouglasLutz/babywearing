# frozen_string_literal: true

class Carrier < ApplicationRecord
  belongs_to :home_location, class_name: 'Location'
  belongs_to :current_location, class_name: 'Location'
  has_many :loans
  belongs_to :category

  scope :search_manufacturer, -> (query)  { where("manufacturer ilike ?", "%#{query}%") }
  scope :search_model, -> (query)  { where("model ilike ?", "%#{query}%") }
  scope :search_name, -> (query)  { where("name ilike ?", "%#{query}%") }
  scope :with_category_id, ->(category_id) { where("category_id = ?", category_id) }
  scope :with_current_location_id, ->(current_location_id) { where("current_location_id = ?", current_location_id) }
  scope :with_status, ->(status) { where("status = ?", self.statuses[status.downcase]) }

  validates :item_id, uniqueness: { message: 'Item ID has already been taken' }
  validates_presence_of [
    :name,
    :item_id,
    :home_location_id,
    :current_location_id,
    :default_loan_length_days,
    :category_id
  ]

  has_many_attached :photos

  enum status: %i[available unavailable disabled sold]

  filterrific(
    available_filters: [
      :with_category_id,
      :with_current_location_id,
      :with_status,
      :search_name,
      :search_manufacturer,
      :search_model
    ]
  )

  alias available_for_checkout? available?

  def build_loan(attributes = {})
    loans.create({
      due_date: Date.today + default_loan_length_days.days
    }.merge(attributes))
  end

  def self.options_for_category_filter
    Category.order(:name).map { |c| [c.name, c.id] }
  end

  def self.options_for_current_location_filter
    Location.order(:name).map { |l| [l.name, l.id] }
  end

  def self.options_for_status_filter
    self.statuses.keys.sort.map{|s| s.titleize}
  end

end
