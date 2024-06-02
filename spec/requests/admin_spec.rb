require 'rails_helper'

RSpec.describe 'Admin', type: :request do
  let(:admin_url_helpers) {
    RailsAdmin::Engine.routes.url_helpers
  }

  let(:model_name) {
    RailsAdmin::ApplicationController.new.to_model_name(Approval.name)
  }

  let(:user) {
    {
      email: 'admin@example.com',
      password: 'admin'
    }
  }

  let(:worker) {
    {
      email: 'worker1@example.com',
      password: 'worker1'
    }
  }

  let(:find_worker) {
    User.find_by!(email: worker[:email])
  }

  let(:worker_approval) {
    Approval.where(created_by_id: find_worker.id, status: 'created').order(:id).limit(1).first
  }

  it 'should authorize, change worker\'s approval status, and worker must receive e-mail' do
    post user_session_path, params: { user: user }
    expect(response).to redirect_to(root_path)

    object = worker_approval
    post admin_url_helpers.state_path(model_name: model_name, id: object.id, event: 'consider', attr: 'status')
    expect(response).to redirect_to(admin_url_helpers.index_path(model_name: model_name))

    expect(object.reload.status).to eq 'considering'

    expect(ActionMailer::Base.deliveries.select do |mail|
      mail.to.include? find_worker.email
    end.count).to eq(1)
  end

  it 'should not be able to use worker action' do
    post user_session_path, params: { user: user }
    aroot_path = root_path
    expect(response).to redirect_to(aroot_path)

    get admin_url_helpers.approval_worker_new_path(model_name: model_name)
    expect(response).to redirect_to(aroot_path)
  end
end
