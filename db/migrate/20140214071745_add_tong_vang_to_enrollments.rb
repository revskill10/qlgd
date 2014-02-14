class AddTongVangToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :tong_vang, :integer
  end
end
