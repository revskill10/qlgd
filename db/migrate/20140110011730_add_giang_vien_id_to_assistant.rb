class AddGiangVienIdToAssistant < ActiveRecord::Migration
  def change
    add_column :assistants, :giang_vien_id, :integer
  end
end
