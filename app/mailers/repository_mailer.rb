# frozen_string_literal: true

class RepositoryMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def check_report(user, check)
    @user = user
    @check = check
    @repository = check.repository

    mail(to: @user.email, subject: "Отчёт о проверке репозитория #{@repository.full_name}")
  end
end
