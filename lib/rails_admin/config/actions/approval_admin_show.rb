module RailsAdmin
  module Config
    module Actions
      class ApprovalAdminShow < RailsAdmin::Config::Actions::Show
        include RailsAdmin::Config::ApprovalAdminHelper
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :route_fragment do
          "admin"
        end
      end
    end
  end
end
