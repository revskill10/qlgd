class Calendar < ActiveRecord::Base
  attr_accessible :so_tiet, :so_tuan, :thu, :tiet_bat_dau, :tuan_hoc_bat_dau
  belongs_to :lop_mon_hoc
end
