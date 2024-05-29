module RailsAdmin
  module Config
    module Actions
      class ApprovalWorkerShow < RailsAdmin::Config::Actions::Show
        include RailsAdmin::Config::ApprovalWorkerHelper
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :route_fragment do
          "worker"
        end
      end
    end
  end
end
