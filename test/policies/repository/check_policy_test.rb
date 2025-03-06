# frozen_string_literal: true

require 'test_helper'

class Repository::CheckPolicyTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @other_user = users(:two)
    @repository = repositories(:one)
    @check = repository_checks(:one)
  end

  test 'show? permits access if user owns the repository' do
    assert_predicate Repository::CheckPolicy.new(@user, @check), :show?
  end

  test 'show? denies access if user does not own the repository' do
    assert_not_predicate Repository::CheckPolicy.new(@other_user, @check), :show?
  end

  test 'show? denies access if user is nil' do
    assert_not_predicate Repository::CheckPolicy.new(nil, @check), :show?
  end

  test 'create? permits access if user owns the repository' do
    assert_predicate Repository::CheckPolicy.new(@user, @check), :create?
  end

  test 'create? denies access if user does not own the repository' do
    assert_not_predicate Repository::CheckPolicy.new(@other_user, @check), :create?
  end

  test 'create? denies access if user is nil' do
    assert_not_predicate Repository::CheckPolicy.new(nil, @check), :create?
  end
end
