class AddGioiTinhToSinhVien < ActiveRecord::Migration
  def change
    add_column :sinh_viens, :gioi_tinh, :integer
  end
end
