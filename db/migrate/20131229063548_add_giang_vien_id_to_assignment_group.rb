class AddGiangVienIdToAssignmentGroup < ActiveRecord::Migration
  def change
    add_column :assignment_groups, :giang_vien_id, :integer
  end
end
