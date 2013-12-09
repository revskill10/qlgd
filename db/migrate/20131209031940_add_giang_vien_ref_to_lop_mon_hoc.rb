class AddGiangVienRefToLopMonHoc < ActiveRecord::Migration
  def change
    add_column :lop_mon_hocs, :giang_vien_id, :integer
    add_index :lop_mon_hocs, :giang_vien_id
  end
end
