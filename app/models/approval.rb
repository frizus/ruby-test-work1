class Approval < ApplicationRecord
  self.inheritance_column = :type1
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :status_last_change_by, class_name: 'User', foreign_key: 'status_last_change_by_id'

  scope :not_answered, -> { where(status: %w(created restored considering))}

  # https://vitalyliber.medium.com/how-to-translate-enum-in-rails-admin-ec001456e629
  enum type: %w(vacation time_off).each_with_object({}) { |e, h| h[e] = e }
  enum status: %w(created deleted restored considering approved denied).each_with_object({}) { |e, h| h[e] = e }

  def type_enum
    self.class.types.each_with_object({}) do |(_, v), h|
      h[I18n.t("activerecord.attributes.type.#{v}")] = v
    end
  end

  def status_enum
    self.class.statuses.each_with_object({}) do |(_, v), h|
      h[I18n.t("activerecord.attributes.status.#{v}")] = v
    end
  end

  validates :type, presence: true
  validates :period_from, presence: true
  validates :period_to, presence: true

  rails_admin do
    list do
      field :type do
        pretty_value do
          value ? I18n.t("activerecord.attributes.type.#{value}") : '-'
        end
      end
      field :status do
        pretty_value do
          value ? I18n.t("activerecord.attributes.status.#{value}") : '-'
        end
      end
    end
  end
end
