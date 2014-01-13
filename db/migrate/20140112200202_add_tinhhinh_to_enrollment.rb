class AddTinhhinhToEnrollment < ActiveRecord::Migration
  def change
    add_column :enrollments, :tinhhinh, :decimal
  end
end
