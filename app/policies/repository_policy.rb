# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def create?
    @user == record.user
  end

  class Scope < ApplicationPolicy::Scope
  end
end
