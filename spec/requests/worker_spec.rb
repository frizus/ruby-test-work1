require 'rails_helper'

RSpec.describe 'Worker', type: :request do
  let(:admin_url_helpers) {
    RailsAdmin::Engine.routes.url_helpers
  }

  let(:model_name) {
    RailsAdmin::ApplicationController.new.to_model_name(Approval.name)
  }

  let(:user) {
    {
      email: 'worker1@example.com',
      password: 'worker1'
    }
  }

  let(:approval) {
    format = ::I18n.t(:long, scope: [:time, :formats], raise: true) rescue '%B %d, %Y %H:%M'
    {
      type: 'vacation',
      period_from: Date.today.strftime(format),
      period_to: 14.days.from_now.strftime(format),
      comment: 'workers_spec test'
    }
  }

  let(:last_approval_count) {
    Approval.where(comment: approval[:comment]).count
  }

  let(:admin) {
    User.admins.limit(1).first
  }

  it 'should authorize, create new approval, and admin must receive e-mail' do
    post user_session_path, params: { user: user }
    expect(response).to redirect_to(root_path)

    remembered_last_approval_count = last_approval_count
    post admin_url_helpers.approval_worker_new_path(model_name: model_name), params: { approval: approval }
    expect(response).to redirect_to(admin_url_helpers.index_path(model_name: model_name))
    expect(Approval.limit(2).where(comment: approval[:comment]).count).to be > remembered_last_approval_count

    if admin
      expect(ActionMailer::Base.deliveries.select do |mail|
        mail.to.include? admin.email
      end.count).to eq(1)
    else
      puts 'No admins found, can\'t check if e-mail was sent to admins'
    end
  end

  it 'should not be able to use admin action' do
    post user_session_path, params: { user: user }
    aroot_path = root_path
    expect(response).to redirect_to(aroot_path)

    get admin_url_helpers.export_path(model_name: model_name)
    expect(response).to redirect_to(aroot_path)
  end
end
