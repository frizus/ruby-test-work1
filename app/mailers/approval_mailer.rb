class ApprovalMailer < ApplicationMailer
  def admins_email(object, previous_status = nil)
    prepare_data(object, previous_status)
    User.admins.select('id', 'email').find_in_batches(batch_size: 100) do |group| # Оставлю на другой раз отправку писем по одному через ActionJob
      emails = group.collect(&:email).join(",")
      mail(
        to: emails,
        subject: @subject,
        content_transfer_encoding: '7bit' # чтобы смотреть письма в tmp/mails (возможно, есть способ лучше смотреть отправленные письма (не preview), но я не знаю) ставим такую кодировку https://stackoverflow.com/questions/10543694/rails-actionmailer-encoding
      )
    end
  end

  def worker_email(object, previous_status = nil)
    prepare_data(object, previous_status)
    return if @object.created_by_id.nil? || @object.created_by.nil? || @object.created_by.email.nil?

    mail(
      to: @object.created_by.email,
      subject: @subject,
      content_transfer_encoding: '7bit'
    )
  end

  private

  def prepare_data(object, previous_status)
    @object = object
    @previous_status = previous_status
    # @changed_by = params[:changed_by] || (params[:changed_by_id] && User.find(params[:changed_by_id]))
    @subject = "Статус заявки ##{@object.id} на #{t("activerecord.attributes.type.#{@object.type}")}: #{@object.status_formatted}"
    if @previous_status
      @subject += " (был #{@object.status_formatted(@previous_status)})"
    end
  end
end
