class AddTenMonHocToLopMonHoc < ActiveRecord::Migration
  def change
    add_column :lop_mon_hocs, :ten_mon_hoc, :string
  end
end
