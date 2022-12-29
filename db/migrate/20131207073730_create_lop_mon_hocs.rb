class CreateLopMonHocs < ActiveRecord::Migration
  def change
    create_table :lop_mon_hocs do |t|
      t.string :ma_lop
      t.string :ma_mon_hoc
      t.string :ma_giang_vien
      t.text :settings
      t.string :state

      t.timestamps
    end    
  end
end
