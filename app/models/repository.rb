# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user

  enumerize :language, in: %w[ruby], predicates: true

  validates :name, :github_id, :full_name, :language, :clone_url, :ssh_url, presence: true
  validates :github_id, uniqueness: true
end
