class ChangeColumnLichGiangDay < ActiveRecord::Migration
  def change
  	rename_column :lich_trinh_giang_days, :type, :ltype
  end
end
