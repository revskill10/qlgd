class Enrollment < ActiveRecord::Base


  
  belongs_to :lop_mon_hoc
  belongs_to :sinh_vien
  has_many :lich_trinh_giang_days, :through => :lop_mon_hoc
  validates :lop_mon_hoc, :sinh_vien, :presence => true

  has_many :attendances, :through => :sinh_vien do 
  	def with_lich(lich)
  		where("lich_trinh_giang_day_id = ?", lich.id).first
  	end
  end
end
