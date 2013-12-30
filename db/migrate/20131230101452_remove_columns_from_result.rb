class RemoveColumnsFromResult < ActiveRecord::Migration
  def change
  	remove_column :results, :lich_trinh_giang_day_id
  	remove_column :results, :user_id
  end
end
