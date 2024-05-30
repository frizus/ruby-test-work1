Dir[Rails.root.join('lib', 'rails_admin', 'config', '*.rb'),].each do |file|
  require file
end
Dir[Rails.root.join('lib', 'rails_admin', 'config', 'actions', '*.rb'),].each do |file|
  require file
end

RailsAdmin.config do |config|
  config.parent_controller = 'ApplicationController'

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == CancanCan ==
  config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    export
    new
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show

    state

    approval_worker_new
  end

  config.model 'Approval' do
    list do
      scopes [nil, :not_answered, :considering, :approved, :denied, :trashed]

      field :id
      field :status, :state
      field :created_by do
        pretty_value do
          if label = bindings[:object].public_send(name).email rescue false
            bindings[:view].link_to(
              label,
              RailsAdmin::Engine.routes.url_helpers.show_path(
                model_name: 'user',
                id: bindings[:object].created_by_id
              ),
              target: '_blank'
            )
          else
            bindings[:object].created_by_id
          end
        end
      end

      fields :type, :period_from, :period_to, :comment
      fields :created_by, :created_at, :updated_at do
        visible do
          bindings[:view]._current_user.admin?
        end
      end
    end
    # https://github.com/zcpdog/rails_admin_aasm/issues/3
    state({
      events: {trash: 'btn-default', restore: 'btn-default', consider: 'btn-default', approve: 'btn-success', deny: 'btn-warning'},
      states: {created: 'label-primary', trashed: 'label-danger', restored: 'label-primary', considering: 'label-info', approved: 'label-success', denied: 'label-danger'}
    })
    edit do
      fields :id do
        read_only true
        visible true
      end
      fields :type, :period_from, :period_to, :comment
      field :created_by_id do
        default_value do
          bindings[:view]._current_user.id
        end
      end
      fields :created_by_id, :status do
        visible do
          bindings[:view]._current_user.admin?
        end
      end
      fields :created_at, :updated_at do
        read_only true
        visible true
      end
    end
    show do
      field :id
      field :status
      fields :type, :period_from, :period_to, :created_at, :updated_at
      field :created_by do
        pretty_value do
          bindings[:view].link_to(
            bindings[:object].public_send(name).email,
            RailsAdmin::Engine.routes.url_helpers.show_path(
              model_name: 'user',
              id: bindings[:object].created_by_id
            ),
            target: '_blank'
          )
        end
      end
      fields :created_by_id, :status do
        visible do
          bindings[:view]._current_user.admin?
        end
      end
    end
  end
end
