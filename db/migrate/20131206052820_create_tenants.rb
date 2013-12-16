class CreateTenants < ActiveRecord::Migration
  def change    
    create_table :tenants do |t|
      t.string :hoc_ky
      t.string :nam_hoc
      t.datetime :ngay_bat_dau
      t.datetime :ngay_ket_thuc
      t.string :name

      t.timestamps
    end
  end
end
