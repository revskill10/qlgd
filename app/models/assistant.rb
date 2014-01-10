class Assistant < ActiveRecord::Base
  attr_accessible :lop_mon_hoc_id, :user_id, :giang_vien_id

  belongs_to :user
  belongs_to :lop_mon_hoc
  belongs_to :giang_vien
  

  validates :user, :giang_vien, :lop_mon_hoc, :presence => true

  def get_lichs
  	lop_mon_hoc.lich_trinh_giang_days.with_giang_vien(giang_vien_id)
  end
end
