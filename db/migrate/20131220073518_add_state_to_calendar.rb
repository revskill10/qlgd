class AddStateToCalendar < ActiveRecord::Migration
  def change
    add_column :calendars, :state, :string
  end
end
