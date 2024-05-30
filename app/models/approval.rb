# == Schema Information
#
# Table name: approvals
#
#  id            :integer          not null, primary key
#  type          :string
#  created_by_id :integer
#  period_from   :date
#  period_to     :date
#  comment       :text
#  status        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_approvals_on_created_by_id  (created_by_id)
#

class Approval < ApplicationRecord
  include AASM

  aasm column: 'status' do
    state :created, initial: true
    state :trashed
    state :restored
    state :considering
    state :approved
    state :denied

    event :trash do
      transitions from: %i(created restored), to: :trashed
    end
    event :restore do
      transitions from: %i(trashed), to: :restored
    end
    event :consider do
      transitions from: %i(created restored denied approved), to: :considering
    end
    event :approve do
      transitions from: %i(created restored considering denied), to: :approved
    end
    event :deny do
      transitions from: %i(created restored considering approved), to: :denied
    end
  end

  self.inheritance_column = :type1
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'

  scope :not_answered, -> { where(status: %w(created restored considering))}

  # https://vitalyliber.medium.com/how-to-translate-enum-in-rails-admin-ec001456e629
  enum type: %w(vacation time_off).each_with_object({}) { |e, h| h[e] = e }
  enum status: %w(created trashed restored considering approved denied).each_with_object({}) { |e, h| h[e] = e }

  def type_enum
    self.class.types.each_with_object({}) do |(_, v), h|
      h[I18n.t("activerecord.attributes.type.#{v}")] = v
    end
  end

  def status_enum
    self.class.statuses.each_with_object({}) do |(_, v), h|
      h[self.class.aasm.human_event_name(v)] = v
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
      # field :status do
      #   pretty_value do
      #     value ? I18n.t("activerecord.attributes.status.#{value}") : '-'
      #   end
      # end
    end
  end
end
