class AddTypeToLichTrinhGiangDays < ActiveRecord::Migration
  def change
    add_column :lich_trinh_giang_days, :type, :string
  end
end
