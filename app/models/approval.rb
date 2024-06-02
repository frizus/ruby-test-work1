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
    # TODO сделать отправку письма при стартовом статусе
    state :created, initial: true
    state :trashed
    state :restored
    state :considering
    state :approved
    state :denied

    event :trash, after_commit: :send_email do
      transitions from: %i(created restored), to: :trashed
    end
    event :restore, after_commit: :send_email do
      transitions from: %i(trashed), to: :restored
    end
    event :consider, after_commit: :send_email do
      transitions from: %i(created restored denied approved), to: :considering
    end
    event :approve, after_commit: :send_email do
      transitions from: %i(created restored considering denied), to: :approved
    end
    event :deny, after_commit: :send_email do
      transitions from: %i(created restored considering approved), to: :denied
    end
  end

  def send_email
    if %w(created restored trashed).include? status
      ApprovalMailer.admins_email(self, aasm.from_state).deliver_now
    elsif %w(considering approved denied).include? status
      ApprovalMailer.worker_email(self, aasm.from_state).deliver_now
    end
  end

  def editable_by_worker?
    status == 'created' || status == 'restored'
  end

  after_commit :send_email_on_create_status, on: :create

  def send_email_on_create_status
    return unless status == self.class.aasm.initial_state.to_s

    send_email
  end

  self.inheritance_column = :type1
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'

  validates :type, presence: true
  validates :period_from, presence: true
  validates :period_to, presence: true
  validate :period_to_must_be_no_less_than_period_from
  validate :date_is_not_less_than_today

  def period_to_must_be_no_less_than_period_from
    errors.add(:period_to, 'must be not less than Period from') if period_to < period_from
  end

  def date_is_not_less_than_today
    errors.add(:period_from, 'must not be in the past') if period_from < Date.today
    errors.add(:period_to, 'must not be in the past') if period_to < Date.today
  end

  scope :not_answered, -> { where(status: %w(created restored considering)) }

  # https://vitalyliber.medium.com/how-to-translate-enum-in-rails-admin-ec001456e629
  enum type: %w(vacation time_off).each_with_object({}) { |e, h| h[e] = e }
  enum status: %w(created trashed restored considering approved denied).each_with_object({}) { |e, h| h[e] = e }

  def type_enum
    self.class.types.each_with_object({}) do |(_, v), h|
      h[I18n.t("activerecord.attributes.type.#{v}")] = v
    end
  end

  def status_formatted(specific_status = nil)
    specific_status = status if specific_status.nil?
    self.class.aasm.human_event_name(specific_status)
  end

  def status_enum
    self.class.statuses.each_with_object({}) do |(_, v), h|
      h[status_formatted(v)] = v
    end
  end

  rails_admin do
    list do
      field :type do
        pretty_value do
          value ? I18n.t("activerecord.attributes.type.#{value}") : '-'
        end
      end
    end
  end
end
