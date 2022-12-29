class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :lich_trinh_giang_day_id
      t.integer :so_tiet_vang
      t.boolean :phep
      t.string :state
      t.integer :sinh_vien_id
      t.text :note

      t.timestamps
    end
  end
end
