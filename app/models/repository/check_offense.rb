# frozen_string_literal: true

class Repository::CheckOffense < ApplicationRecord # rubocop:disable Style/ClassAndModuleChildren
  belongs_to :check
end
