module RailsAdmin
  module Config
    module Actions
      class ApprovalWorkerEdit < RailsAdmin::Config::Actions::Edit
        include RailsAdmin::Config::ApprovalWorkerHelper
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :route_fragment do
          "worker/edit"
        end
      end
    end
  end
end
