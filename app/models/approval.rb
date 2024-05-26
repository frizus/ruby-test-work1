class Approval < ApplicationRecord
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :status_last_change_by, class_name: 'User', foreign_key: 'status_last_change_by_id'
end
