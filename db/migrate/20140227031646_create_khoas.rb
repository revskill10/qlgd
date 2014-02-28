class CreateKhoas < ActiveRecord::Migration
  def change
    create_table :khoas do |t|
      t.string :ten_khoa
      t.integer :giang_vien_id

      t.timestamps
    end
  end
end
