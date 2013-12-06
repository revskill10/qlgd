class CreateGiangViens < ActiveRecord::Migration
  def change
    create_table :giang_viens do |t|
      t.string :ho
      t.string :dem
      t.string :ten
      t.string :code
      t.string :ten_khoa

      t.timestamps
    end
  end
end
