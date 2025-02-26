# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def show?
    user.present? && record.user == user
  end

  def new?
    user.present?
  end

  def create?
    user.present?
  end

  class Scope < ApplicationPolicy::Scope
  end
end
