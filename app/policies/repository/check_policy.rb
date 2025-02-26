# frozen_string_literal: true

class Repository::CheckPolicy < ApplicationPolicy # rubocop:disable Style/ClassAndModuleChildren
  def show?
    user_owns_repository?
  end

  def create?
    user_owns_repository?
  end

  private

  def user_owns_repository?
    @user == record.repository.user
  end

  class Scope < ApplicationPolicy::Scope
  end
end
