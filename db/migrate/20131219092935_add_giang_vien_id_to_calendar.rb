class AddGiangVienIdToCalendar < ActiveRecord::Migration
  def change
    add_column :calendars, :giang_vien_id, :integer
  end
end
