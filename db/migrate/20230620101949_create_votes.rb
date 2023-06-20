class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.belongs_to :votable, polymorphic: true, null: false
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :value

      t.timestamps
    end
  end
end
