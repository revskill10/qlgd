class ChangeGiangVienToUserInLop < ActiveRecord::Migration
  def up
  	rename_column :assignment_groups, :giang_vien_id, :user_id
  	rename_column :assignments, :giang_vien_id, :user_id
  	rename_column :submissions, :giang_vien_id, :user_id
  end

  def down
  end
end
