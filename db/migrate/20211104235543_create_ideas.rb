class CreateIdeas < ActiveRecord::Migration[6.1]
  def change
    create_table :ideas do |t|
      t.references :category, type: :bigint, foreign_key: true, null: false
      t.text :body, null: false, comment: "アイデア本文"

      t.timestamps
    end
  end
end
