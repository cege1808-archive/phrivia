class AddQuestion < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :question
      t.references :player
      t.timestamps null: false
    end
  end
end
