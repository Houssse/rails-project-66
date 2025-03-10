# frozen_string_literal: true

class AddPassedToRepositoryChecks < ActiveRecord::Migration[7.1]
  def change
    add_column :repository_checks, :passed, :boolean, default: false, null: false
  end
end
