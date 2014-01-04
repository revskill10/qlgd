class AddPhongToCalendar < ActiveRecord::Migration
  def change
    add_column :calendars, :phong, :string
  end
end
