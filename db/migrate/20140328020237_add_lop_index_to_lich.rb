class AddLopIndexToLich < ActiveRecord::Migration
  def change
  	add_index :du_gios, :lich_trinh_giang_day_id
  	add_index :du_gios, :user_id
  	add_index :group_submissions, :enrollment_id
  	add_index :group_submissions, :assignment_group_id
  	add_index :lich_trinh_giang_days, :moderator_id
  	add_index :lich_trinh_giang_days, :user_id
  	add_index :submissions, :assignment_id
  	add_index :submissions, :enrollment_id
  	add_index :user_groups, :user_id
  	add_index :user_groups, :group_id
  	add_index :users, :imageable_id
  	add_index :vi_phams, :lich_trinh_giang_day_id
  	add_index :vi_phams, :user_id
  	add_index :khoas, :giang_vien_id
  end
end

