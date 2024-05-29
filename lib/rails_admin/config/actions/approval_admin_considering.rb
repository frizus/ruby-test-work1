module RailsAdmin
  module Config
    module Actions
      class ApprovalAdminConsidering < RailsAdmin::Config::Actions::Delete
        include RailsAdmin::Config::ApprovalAdminHelper
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :route_fragment do
          "admin/considering"
        end
      end
    end
  end
end
