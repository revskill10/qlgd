class Enrollment < ActiveRecord::Base


  
  belongs_to :lop_mon_hoc
  belongs_to :sinh_vien

  has_many :lich_trinh_giang_days, :through => :lop_mon_hoc
  validates :lop_mon_hoc, :sinh_vien, :presence => true
  has_many :assignment_groups, :through => :lop_mon_hoc, :uniq => true
  has_many :assignments, :through => :lop_mon_hoc, :uniq => true
  has_many :attendances, :through => :sinh_vien
  has_many :submissions, :through => :sinh_vien
  def tong_vang
  	attendances.not_idle.where('phep is NULL or phep=false').sum(:so_tiet_vang)
  end
  def so_tiet_thua
    attendances.idle.inject(0) {|res, at| res + at.lich_trinh_giang_day.so_tiet_moi }
  end
  def diem_qua_trinh
  	assignment_groups.to_a.sum {|e| e.diem_trung_binh(sinh_vien.id) }
  end

end
