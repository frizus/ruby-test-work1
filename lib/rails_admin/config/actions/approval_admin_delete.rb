module RailsAdmin
  module Config
    module Actions
      class ApprovalAdminDelete < RailsAdmin::Config::Actions::Delete
        include RailsAdmin::Config::ApprovalAdminHelper
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :route_fragment do
          "admin/delete"
        end
      end
    end
  end
end
