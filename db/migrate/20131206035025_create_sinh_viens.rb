class CreateSinhViens < ActiveRecord::Migration
  def change
    create_table :sinh_viens do |t|
      t.string :ho
      t.string :dem
      t.string :ten
      t.datetime :ngay_sinh
      t.string :code
      t.string :ma_lop_hanh_chinh

      t.timestamps
    end
  end
end
