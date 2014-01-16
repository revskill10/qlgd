class CreateViPhams < ActiveRecord::Migration
  def change
    create_table :vi_phams do |t|
      t.integer :lich_trinh_giang_day_id
      t.boolean :di_muon
      t.boolean :ve_som
      t.boolean :bo_tiet
      t.text :note1
      t.text :note2
      t.text :note3
      t.string :state

      t.timestamps
    end
  end
end
