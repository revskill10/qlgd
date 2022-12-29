class RemoveGiangVienFromGrade < ActiveRecord::Migration
  def up
  	remove_column :assignment_groups, :user_id
  	remove_column :assignments, :user_id
  	remove_column :submissions, :user_id
  end

  def down
  end
end
