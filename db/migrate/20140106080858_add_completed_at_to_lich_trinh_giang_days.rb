class AddCompletedAtToLichTrinhGiangDays < ActiveRecord::Migration
  def change
    add_column :lich_trinh_giang_days, :completed_at, :datetime
  end
end
