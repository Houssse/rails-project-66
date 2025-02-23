# frozen_string_literal: true

require 'test_helper'

class Repository::CheckPolicyTest < ActiveSupport::TestCase # rubocop:disable Style/ClassAndModuleChildren
  def setup
    @user = users(:one)
    @other_user = users(:two)
    @repository = repositories(:one)
    @check = repository_checks(:one)
  end

  def test_show
    assert_predicate Repository::CheckPolicy.new(@user, @check), :show?
    assert_not_predicate Repository::CheckPolicy.new(@other_user, @check), :show?
    assert_not_predicate Repository::CheckPolicy.new(nil, @check), :show?
  end

  def test_create
    assert_predicate Repository::CheckPolicy.new(@user, @check), :create?
    assert_not_predicate Repository::CheckPolicy.new(@other_user, @check), :create?
    assert_not_predicate Repository::CheckPolicy.new(nil, @check), :create?
  end

  def test_scope
    @repository_other = repositories(:two)
    @check_other = repository_checks(:two)

    checks = Pundit.policy_scope(@user, Repository::Check)

    assert_includes checks, @check
    assert_not_includes checks, @check_other

    checks = Pundit.policy_scope(nil, Repository::Check)

    assert_empty checks
  end
end
