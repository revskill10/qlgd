class ChangeTongVangToTongTietVang < ActiveRecord::Migration
  def change
  	rename_column :enrollments, :tong_vang, :tong_tiet_vang
  end
end
