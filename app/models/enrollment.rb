class Enrollment < ActiveRecord::Base


  
  belongs_to :lop_mon_hoc
  belongs_to :sinh_vien

  has_many :lich_trinh_giang_days, :through => :lop_mon_hoc
  validates :lop_mon_hoc, :sinh_vien, :presence => true

  has_many :attendances, :through => :sinh_vien

  def tong_vang
  	attendances.where('phep is NULL or phep=false').sum(:so_tiet_vang)
  end

end
