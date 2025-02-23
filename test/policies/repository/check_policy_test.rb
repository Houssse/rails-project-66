require 'test_helper'

class Repository::CheckPolicyTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @other_user = users(:two)
    @repository = repositories(:one)
    @check = repository_checks(:one)
  end

  def test_show
    assert Repository::CheckPolicy.new(@user, @check).show?
    refute Repository::CheckPolicy.new(@other_user, @check).show?
    refute Repository::CheckPolicy.new(nil, @check).show?
  end

  def test_create
    assert Repository::CheckPolicy.new(@user, @check).create?
    refute Repository::CheckPolicy.new(@other_user, @check).create?
    refute Repository::CheckPolicy.new(nil, @check).create?
  end

  def test_scope
    @repository_other = repositories(:two)
    @check_other = repository_checks(:two)
  
    checks = Pundit.policy_scope(@user, Repository::Check)
    assert_includes checks, @check
    refute_includes checks, @check_other
  
    checks = Pundit.policy_scope(nil, Repository::Check)
    assert_empty checks
  end
end
