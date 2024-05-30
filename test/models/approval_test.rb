# == Schema Information
#
# Table name: approvals
#
#  id            :integer          not null, primary key
#  type          :string
#  created_by_id :integer
#  period_from   :datetime
#  period_to     :datetime
#  comment       :text
#  status        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_approvals_on_created_by_id  (created_by_id)
#

require 'test_helper'

class ApprovalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
