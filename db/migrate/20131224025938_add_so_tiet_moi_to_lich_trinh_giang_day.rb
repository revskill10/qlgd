class AddSoTietMoiToLichTrinhGiangDay < ActiveRecord::Migration
  def change
    add_column :lich_trinh_giang_days, :so_tiet_moi, :integer
  end
end
