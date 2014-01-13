class AddPositionToSinhVien < ActiveRecord::Migration
  def change
    add_column :sinh_viens, :position, :integer
  end
end
