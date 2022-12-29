class AddGiangVienIdToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :giang_vien_id, :integer
  end
end
