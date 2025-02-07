# frozen_string_literal: true

module Repository
  class Check < ApplicationRecord
    belongs_to :repository, class_name: 'Repository::Base'
  end
end
