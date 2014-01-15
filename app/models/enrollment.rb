class Enrollment < ActiveRecord::Base

  default_scope includes(:sinh_vien).order('sinh_viens.position')
  
  belongs_to :lop_mon_hoc
  belongs_to :sinh_vien

  has_many :lich_trinh_giang_days, :through => :lop_mon_hoc
  validates :lop_mon_hoc, :sinh_vien, :presence => true
  has_many :assignment_groups, :through => :lop_mon_hoc, :uniq => true
  has_many :assignments, :through => :lop_mon_hoc, :uniq => true
  has_many :attendances, :through => :sinh_vien
  has_many :submissions, :dependent => :destroy
  def tong_vang
    attendances.where(lich_trinh_giang_day_id: lich_trinh_giang_days.map(&:id)).not_idle.where('phep is NULL or phep=false').sum(:so_tiet_vang)
  end
  def so_tiet_thua
    attendances.idle.inject(0) {|res, at| res + at.lich_trinh_giang_day.so_tiet_moi }
  end
  def diem_qua_trinh
          assignment_groups.to_a.sum {|e| e.diem_trung_binh(sinh_vien.id) }
  end

  def tinhhinhvang
    return 0 if lop_mon_hoc.tong_so_tiet_hoc == 0
    (tong_vang * 100.0 / (lop_mon_hoc.tong_so_tiet_hoc - so_tiet_thua)).round(2)
  end

end