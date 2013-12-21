class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.integer :lop_mon_hoc_id
      t.integer :sinh_vien_id

      t.timestamps
    end
  end
end
