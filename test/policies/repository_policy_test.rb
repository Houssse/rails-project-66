# frozen_string_literal: true

require 'test_helper'

class RepositoryPolicyTest < ActiveSupport::TestCase
  require 'test_helper'

  class RepositoryPolicyTest < ActiveSupport::TestCase
    def setup
      @user = users(:one)
      @other_user = users(:two)
      @repository = repositories(:one)
    end

    def test_scope
      assert_includes Pundit.policy_scope(@user, Repository), @repository
      assert_not_includes Pundit.policy_scope(@other_user, Repository), @repository
    end

    def test_index
      assert_predicate RepositoryPolicy.new(@user, Repository), :index?
      assert_not_predicate RepositoryPolicy.new(nil, Repository), :index?
    end

    def test_show
      assert_predicate RepositoryPolicy.new(@user, @repository), :show?
      assert_not_predicate RepositoryPolicy.new(@other_user, @repository), :show?
      assert_not_predicate RepositoryPolicy.new(nil, @repository), :show?
    end

    def test_new
      assert_predicate RepositoryPolicy.new(@user, Repository), :new?
      assert_not_predicate RepositoryPolicy.new(nil, Repository), :new?
    end

    def test_create
      assert_predicate RepositoryPolicy.new(@user, Repository), :create?
      assert_not_predicate RepositoryPolicy.new(nil, Repository), :create?
    end
  end
end
