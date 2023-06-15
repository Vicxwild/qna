class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.string :title, null: false
      t.belongs_to :question, foreign_key: true, null: false
      t.belongs_to :answer, foreign_key: true

      t.timestamps
    end
  end
end
