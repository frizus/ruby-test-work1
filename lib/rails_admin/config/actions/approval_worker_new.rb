module RailsAdmin
  module Config
    module Actions
      class ApprovalWorkerNew < RailsAdmin::Config::Actions::New
        include RailsAdmin::Config::ApprovalWorkerHelper
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :route_fragment do
          "worker/new"
        end
      end
    end
  end
end
