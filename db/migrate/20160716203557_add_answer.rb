class AddAnswer < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :answer
      t.references :player
      t.references :question
      t.timestamps null: false
    end
  end
end
