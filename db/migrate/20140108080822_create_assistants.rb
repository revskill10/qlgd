class CreateAssistants < ActiveRecord::Migration
  def change
    create_table :assistants do |t|
      t.integer :user_id
      t.integer :lop_mon_hoc_id

      t.timestamps
    end
  end
end
