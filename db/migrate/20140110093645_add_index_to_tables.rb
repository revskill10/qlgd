class AddIndexToTables < ActiveRecord::Migration
  def change
  	add_index :assignment_groups, :lop_mon_hoc_id
    add_index :assignments, [:lop_mon_hoc_id, :assignment_group_id]
    add_index :assistants, [:lop_mon_hoc_id, :giang_vien_id]
    add_index :assistants, :user_id
    add_index :attendances, [:lich_trinh_giang_day_id, :sinh_vien_id]
    add_index :attendances, :state
    add_index :calendars, [:lop_mon_hoc_id, :giang_vien_id]
    add_index :enrollments, [:lop_mon_hoc_id, :sinh_vien_id]
    add_index :giang_viens, :code
    add_index :lich_trinh_giang_days, [:lop_mon_hoc_id, :giang_vien_id]
    add_index :lich_trinh_giang_days, [:giang_vien_id, :lop_mon_hoc_id]
    add_index :submissions, [:sinh_vien_id, :assignment_id]
  end
end
