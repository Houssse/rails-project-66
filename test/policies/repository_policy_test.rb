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

    test 'user can create a repository for themselves' do
      policy = RepositoryPolicy.new(@user, @repository)

      assert_predicate policy, :create?
    end

    test 'user cannot create a repository for another user' do
      policy = RepositoryPolicy.new(@other_user, @repository)

      assert_not_predicate policy, :create?
    end
  end
end
