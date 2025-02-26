# frozen_string_literal: true

require 'test_helper'

class RepositoryPolicyTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @other_user = users(:two)
    @repository = repositories(:one)
  end

  test 'show? permits access if user owns the repository' do
    assert_predicate RepositoryPolicy.new(@user, @repository), :show?
  end

  test 'show? denies access if user does not own the repository' do
    assert_not_predicate RepositoryPolicy.new(@other_user, @repository), :show?
  end

  test 'new? permits access if user owns the repository' do
    assert_predicate RepositoryPolicy.new(@user, @repository), :new?
  end

  test 'new? denies access if user does not own the repository' do
    assert_not_predicate RepositoryPolicy.new(@other_user, @repository), :new?
  end

  test 'create? permits access if user owns the repository' do
    assert_predicate RepositoryPolicy.new(@user, @repository), :create?
  end

  test 'create? denies access if user does not own the repository' do
    assert_not_predicate RepositoryPolicy.new(@other_user, @repository), :create?
  end

  test 'user_owns_record? returns true if user owns the record' do
    policy = RepositoryPolicy.new(@user, @repository)

    assert_predicate policy, :user_owns_record?
  end

  test 'user_owns_record? returns false if user does not own the record' do
    policy = RepositoryPolicy.new(@other_user, @repository)

    assert_not_predicate policy, :user_owns_record?
  end
end
