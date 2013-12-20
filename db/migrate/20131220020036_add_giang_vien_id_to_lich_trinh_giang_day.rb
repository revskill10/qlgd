class AddGiangVienIdToLichTrinhGiangDay < ActiveRecord::Migration
  def change
    add_column :lich_trinh_giang_days, :giang_vien_id, :integer
  end
end
