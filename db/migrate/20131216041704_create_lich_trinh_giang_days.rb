class CreateLichTrinhGiangDays < ActiveRecord::Migration
  def change
    create_table :lich_trinh_giang_days do |t|
      t.datetime :thoi_gian
      t.integer :tuan
      t.text :noi_dung
      t.integer :so_tiet
      t.string :tiet_nghi
      t.integer :tiet_bat_dau
      t.string :phong
      t.integer :lop_mon_hoc_id
      t.boolean :thuc_hanh
      t.string :status
      t.string :state
      t.integer :moderator_id

      t.timestamps
    end
  end
end
