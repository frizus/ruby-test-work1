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

    approval_admin_delete

    approval_worker_delete
    approval_worker_edit
    approval_worker_new
    approval_worker_show
  end

  config.model 'Approval' do
    list do
      scopes [nil, :not_answered]

      field :status, :state

      fields :type, :period_from, :period_to, :comment, :status_comment
      fields :created_by_id, :status_last_change_by_id, :created_at, :updated_at do
        visible do
          bindings[:view]._current_user.admin?
        end
      end
    end
    # https://github.com/zcpdog/rails_admin_aasm/issues/3
    state({
      events: {deleted: 'btn-danger', restored: 'btn-warning', consider: 'btn-success', approve: 'btn-success', deny: 'btn-danger'},
      states: {delete: 'label-important', restore: 'label-warning', consider: 'label-success', approve: 'label-success', deny: 'label-danger'}
    })
    edit do
      fields :type, :period_from, :period_to, :comment
      fields :created_by_id, :status, :status_last_change_by_id, :status_comment, :created_at, :updated_at do
        visible do
          bindings[:view]._current_user.admin?
        end
      end
    end
  end
end
