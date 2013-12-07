class CreateLopMonHocs < ActiveRecord::Migration
  def change
    create_table :lop_mon_hocs do |t|
      t.string :ma_lop
      t.string :ma_mon_hoc
      t.string :ma_giang_vien
      t.hstore :settings
      t.string :state

      t.timestamps
    end
    add_hstore_index :lop_mon_hocs, :settings
  end
end
