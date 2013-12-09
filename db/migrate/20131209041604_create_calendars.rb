class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.integer :so_tiet
      t.integer :so_tuan
      t.integer :thu
      t.integer :tiet_bat_dau
      t.integer :tuan_hoc_bat_dau
      t.integer :lop_mon_hoc_id

      t.timestamps
    end
    add_index :calendars, :lop_mon_hoc_id
  end
end
