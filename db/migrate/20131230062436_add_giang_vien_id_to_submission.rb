class AddGiangVienIdToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :giang_vien_id, :integer
  end
end
