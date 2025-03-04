# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name
      t.string :nickname
      t.string :image_url
      t.string :token

      t.timestamps
    end
  end
end
