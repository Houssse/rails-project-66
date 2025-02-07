# frozen_string_literal: true

class User < ApplicationRecord
  has_many :repositories, class_name: 'Repository::Repo', dependent: :destroy
end
