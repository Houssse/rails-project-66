module Repository
  class CheckOffense < ApplicationRecord
    belongs_to :check, class_name: 'Repository::Check'
  end
end
