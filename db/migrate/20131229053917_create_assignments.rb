class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :assignment_group_id
      t.integer :lop_mon_hoc_id
      t.integer :points
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
