class CreateGroupSubmissions < ActiveRecord::Migration
  def change
    create_table :group_submissions do |t|
      t.integer :enrollment_id
      t.integer :assignment_group_id
      t.decimal :grade

      t.timestamps
    end
  end
end
