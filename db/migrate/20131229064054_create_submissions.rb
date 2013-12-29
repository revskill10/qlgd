class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :assignment_id
      t.integer :sinh_vien_id
      t.decimal :grade

      t.timestamps
    end
  end
end
