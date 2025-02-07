# frozen_string_literal: true

module Repository
  class Repo < ApplicationRecord
    self.table_name = 'repositories'

    extend Enumerize

    belongs_to :user
    has_many :checks, class_name: 'Repository::Check', dependent: :destroy

    enumerize :language, in: %w[ruby], predicates: true

    validates :name, :github_id, :full_name, :language, :clone_url, :ssh_url, presence: true
    validates :github_id, uniqueness: true
  end
end
