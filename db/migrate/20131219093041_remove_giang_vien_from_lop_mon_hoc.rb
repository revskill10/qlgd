class RemoveGiangVienFromLopMonHoc < ActiveRecord::Migration
  def change
  	remove_column :lop_mon_hocs, :ma_giang_vien
  end
end
