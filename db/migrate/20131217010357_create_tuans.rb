class CreateTuans < ActiveRecord::Migration
  def change
    create_table :tuans do |t|
      t.integer :stt
      t.date :tu_ngay
      t.date :den_ngay

      t.timestamps
    end
  end
end
