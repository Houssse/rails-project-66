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
    user.present? && record.repository.user == user
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:repository).where(repositories: { user: user })
    end
  end
end
