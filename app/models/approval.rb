class Approval < ApplicationRecord
  self.inheritance_column = :type1
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :status_last_change_by, class_name: 'User', foreign_key: 'status_last_change_by_id'

  # https://vitalyliber.medium.com/how-to-translate-enum-in-rails-admin-ec001456e629
  enum type: %w(vacation time_off).each_with_object({}) { |e, h| h[e] = e}

  def type_enum
    self.class.types.each_with_object({}) do |(_, v), h|
      h[I18n.t("activerecord.attributes.approval.#{v}")] = v
    end
  end

  validates :type, presence: true
  validates :period_from, presence: true
  validates :period_to, presence: true

  before_create :set_created_by_id

  rails_admin do
    list do
      field :status
      field :type
      field :period_from
      field :period_to
      field :comment
    end
    edit do
      field :type
      field :period_from
      field :period_to
      field :comment
    end
  end
end
