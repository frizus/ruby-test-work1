# frozen_string_literal: true

module RailsAdmin
  module Config
    module ApprovalWorkerHelper
      def self.included(base)
        base.register_instance_option :only do
          ['Approval']
        end
      end
    end
  end
end

