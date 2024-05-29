module RailsAdmin
  module Config
    module Actions
      class ApprovalAdminEdit < RailsAdmin::Config::Actions::Edit
        include RailsAdmin::Config::ApprovalAdminHelper
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :route_fragment do
          "admin/edit"
        end
      end
    end
  end
end
