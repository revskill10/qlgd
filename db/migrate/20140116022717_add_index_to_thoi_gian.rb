class AddIndexToThoiGian < ActiveRecord::Migration
  def change
  	add_index :lich_trinh_giang_days, :thoi_gian  	
  end
end
