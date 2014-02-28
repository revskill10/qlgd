class AddDuyetThongSoAndDuyetLichTrinhAndDuyetTinhHinhToLopMonHoc < ActiveRecord::Migration
  def change
    add_column :lop_mon_hocs, :duyet_thong_so, :boolean
    add_column :lop_mon_hocs, :duyet_lich_trinh, :boolean
    add_column :lop_mon_hocs, :duyet_tinh_hinh, :boolean
  end
end
