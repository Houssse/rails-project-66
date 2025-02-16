# frozen_string_literal: true

module Repository
  class Check < ApplicationRecord
    include AASM

    belongs_to :repository, class_name: 'Repository::Repo', inverse_of: :checks
    has_many :offenses, class_name: 'Repository::CheckOffense', dependent: :destroy

    include AASM

    aasm column: 'state' do
      state :pending, initial: true
      state :cloning
      state :checking
      state :completed
      state :failed

      event :start_cloning do
        transitions from: :pending, to: :cloning
      end

      event :start_checking do
        transitions from: :cloning, to: :checking
      end

      event :complete do
        transitions from: %i[checking cloning], to: :completed
      end

      event :fail do
        transitions from: %i[cloning checking], to: :failed
      end

      event :restart do
        transitions from: %i[completed failed], to: :pending
      end
    end

    def state_label
      I18n.t("activerecord.attributes.repository/check.state.#{aasm.current_state}")
    end

    def run_check!
      start_cloning!
      Repository::CheckJob.perform_later(id)
    end
  end
end
