class AddKhoaAndHeAndNganhToSinhVien < ActiveRecord::Migration
  def change
    add_column :sinh_viens, :khoa, :string
    add_column :sinh_viens, :he, :string
    add_column :sinh_viens, :nganh, :string
  end
end
