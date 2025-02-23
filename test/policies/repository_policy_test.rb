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
      refute_includes Pundit.policy_scope(@other_user, Repository), @repository
    end
  
    def test_index
      assert_predicate RepositoryPolicy.new(@user, Repository), :index?
      refute_predicate RepositoryPolicy.new(nil, Repository), :index?
    end
  
    def test_show
      assert_predicate RepositoryPolicy.new(@user, @repository), :show?
      refute_predicate RepositoryPolicy.new(@other_user, @repository), :show?
      refute_predicate RepositoryPolicy.new(nil, @repository), :show?
    end
  
    def test_new
      assert_predicate RepositoryPolicy.new(@user, Repository), :new?
      refute_predicate RepositoryPolicy.new(nil, Repository), :new?
    end
  
    def test_create
      assert_predicate RepositoryPolicy.new(@user, Repository), :create?
      refute_predicate RepositoryPolicy.new(nil, Repository), :create?
    end
  end
end
