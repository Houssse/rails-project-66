# frozen_string_literal: true

module Repository
  class Check < ApplicationRecord
    belongs_to :repository, class_name: 'Repository::Repo', inverse_of: :checks

    include AASM

    aasm column: 'state' do
      state :checking, initial: true
      state :completed

      event :complete do
        transitions from: :checking, to: :completed
      end

      event :restart do
        transitions from: :completed, to: :checking
      end
    end
  end
end
