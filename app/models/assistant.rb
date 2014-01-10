class Assistant < ActiveRecord::Base
  attr_accessible :lop_mon_hoc_id, :user_id, :giang_vien_id

  belongs_to :user
  belongs_to :lop_mon_hoc
  belongs_to :giang_vien

  has_many :lich_trinh_giang_days, :conditions => proc { "giang_vien_id = #{self.giang_vien_id} and lop_mon_hoc_id = #{self.lop_mon_hoc_id}" }

  validates :user, :giang_vien, :lop_mon_hoc, :presence => true
end
