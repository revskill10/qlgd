class AddBosungToEnrollment < ActiveRecord::Migration
  def change
    add_column :enrollments, :bosung, :boolean
  end
end
