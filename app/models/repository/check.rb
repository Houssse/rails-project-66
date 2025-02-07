# frozen_string_literal: true

module Repository
  class Check < ApplicationRecord
    belongs_to :repository

    include AASM

    aasm column: 'state' do
      state :checking, initial: true
      state :passed, :failed

      event :mark_as_passed do
        transitions from: :checking, to: :passed
      end

      event :mark_as_failed do
        transitions from: :checking, to: :failed
      end

      event :restart_check do
        transitions from: %i[passed failed], to: :checking
      end
    end
  end
end
