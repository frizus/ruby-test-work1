# Preview all emails at http://localhost:3000/rails/mailers/approval_mailer
class ApprovalMailerPreview < ActionMailer::Preview
  def admins_email
    ApprovalMailer.admins_email(Approval.first!)
  end

  def worker_email
    ApprovalMailer.worker_email(Approval.second! || Approval.first!)
  end
end
