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
