class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.text :body, null: false
      t.belongs_to :question, foreign_key: true, null: false

      t.timestamps
    end
  end
end
