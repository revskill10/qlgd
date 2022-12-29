class AddDiemQuaTrinhToEnrollment < ActiveRecord::Migration
  def change
    add_column :enrollments, :diem_qua_trinh, :integer
  end
end
