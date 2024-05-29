module RailsAdmin
  module Config
    module Actions
      class ApprovalAdminDeny < RailsAdmin::Config::Actions::Delete
        include RailsAdmin::Config::ApprovalAdminHelper
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :route_fragment do
          "admin/deny"
        end
      end
    end
  end
end
