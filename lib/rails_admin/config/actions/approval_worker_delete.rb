module RailsAdmin
  module Config
    module Actions
      class ApprovalWorkerDelete < RailsAdmin::Config::Actions::Delete
        include RailsAdmin::Config::ApprovalWorkerHelper
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :route_fragment do
          "worker/delete"
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :authorization_key do
          :approval_worker_delete
        end

        register_instance_option :controller do
          proc do
            redirect_path = nil

            # @auditing_adapter && @auditing_adapter.delete_object(@object, @abstract_model, _current_user)
            if @object.may_trash? && @object.aasm.trash!
              flash[:success] = t('admin.flash.successful', name: @model_config.label, action: t('admin.actions.delete.done'))
              redirect_path = index_path
            else
              flash[:error] = t('admin.flash.error', name: @model_config.label, action: t('admin.actions.delete.done'))
              redirect_path = back_or_index
            end

            redirect_to redirect_path
          end
        end
      end
    end
  end
end
