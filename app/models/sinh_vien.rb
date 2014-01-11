class SinhVien < ActiveRecord::Base
  attr_accessible :code, :dem, :ho, :ma_lop_hanh_chinh, :ngay_sinh, :ten, :gioi_tinh, :he, :khoa, :nganh, :tin_chi

  has_one :user, :as => :imageable
  has_many :attendances, :dependent => :destroy  
  has_many :enrollments, :dependent => :destroy
  has_many :submissions, :through => :enrollments
  has_many :lop_mon_hocs, :through => :enrollments, :uniq => true

  def lich_trinh_giang_days    
    return []if lop_mon_hocs.count == 0
    tmp = []
    lop_mon_hocs.each do |l|
      tmp += l.lich_trinh_giang_days
    end
    tmp
  end
  def hovaten
  	return trans(ho) + trans(dem) + ten
  end

  private
  def trans(x)
  	(x ? x + " " : "")
  end
end
