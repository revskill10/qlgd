class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :question_id
      t.integer :user_id
      t.integer :lich_trinh_giang_day_id
      t.text :data

      t.timestamps
    end
  end
end
