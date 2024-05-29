module RailsAdmin
  module Config
    module Actions
      class ApprovalWorkerDelete < RailsAdmin::Config::Actions::Delete
        include RailsAdmin::Config::ApprovalWorkerHelper
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :route_fragment do
          "worker/delete"
        end
      end
    end
  end
end
