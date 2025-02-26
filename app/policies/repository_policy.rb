# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def show?
    user_owns_record?
  end

  def new?
    user_owns_record?
  end

  def create?
    user_owns_record?
  end

  private

  def user_owns_record?
    user == record.user
  end

  class Scope < ApplicationPolicy::Scope
  end
end
