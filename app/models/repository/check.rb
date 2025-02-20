# frozen_string_literal: true

class Repository::Check < ApplicationRecord # rubocop:disable Style/ClassAndModuleChildren
  include AASM

  belongs_to :repository, class_name: 'Repository', inverse_of: :checks
  has_many :offenses, class_name: 'CheckOffense', dependent: :destroy

  aasm column: 'aasm_state' do
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

  def aasm_state_label
    I18n.t("activerecord.attributes.repository/check.aasm_state.#{aasm.current_state}")
  end

  def run_check!
    start_cloning!
    Repository::CheckJob.perform_later(id)
  end
end
