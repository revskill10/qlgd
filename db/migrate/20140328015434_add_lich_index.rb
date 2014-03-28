class AddLichIndex < ActiveRecord::Migration
  def change
    add_index :lich_trinh_giang_days, :phong
    add_index :lich_trinh_giang_days, :giang_vien_id
    add_index :lich_trinh_giang_days, :tuan
  end

end
