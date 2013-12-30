class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :survey_id
      t.string :name
      t.text :data

      t.timestamps
    end
  end
end
