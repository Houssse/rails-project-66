# frozen_string_literal: true

class CreateRepositoryCheckOffenses < ActiveRecord::Migration[7.1]
  def change
    create_table :repository_check_offenses do |t|
      t.references :check, null: false, foreign_key: { to_table: :repository_checks }
      t.string :file_path
      t.text :message
      t.string :rule_id
      t.integer :line
      t.integer :column

      t.timestamps
    end
  end
end
