class CreatePhongs < ActiveRecord::Migration
  def change
    create_table :phongs do |t|
      t.string :ma_phong
      t.integer :tang
      t.integer :suc_chua_toi_da
      t.integer :loai
      t.string :toa_nha

      t.timestamps
    end
  end
end
