class CreateAssignmentGroups < ActiveRecord::Migration
  def change
    create_table :assignment_groups do |t|
      t.string :name
      t.integer :weight
      t.integer :lop_mon_hoc_id
      t.string :state

      t.timestamps
    end
  end
end
