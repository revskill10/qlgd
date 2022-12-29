class CreateDuGios < ActiveRecord::Migration
  def change
    create_table :du_gios do |t|
      t.integer :lich_trinh_giang_day_id
      t.integer :user_id
      t.string :state
      t.text :settings
      t.text :danh_gia

      t.timestamps
    end
  end
end
