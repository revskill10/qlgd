#encoding: utf-8
class SinhVien < ActiveRecord::Base
  acts_as_list
  include Comparable
  attr_accessible :code, :dem, :ho, :ma_lop_hanh_chinh, :ngay_sinh, :ten, :gioi_tinh, :he, :khoa, :nganh, :tin_chi, :position

  has_one :user, :as => :imageable
  has_many :attendances, :dependent => :destroy  
  has_many :enrollments, :dependent => :destroy
  has_many :submissions, :through => :enrollments
  has_many :lop_mon_hocs, :through => :enrollments, :uniq => true

  FACETS = [:ten, :ma_lop_hanh_chinh, :nganh, :khoa, :he, :hoc_ky, :nam_hoc]
  searchable do
    text :ten, :boost => 5
    text :code, :hovaten, :ma_lop_hanh_chinh, :gioi_tinh, :he, :khoa, :nganh, :tin_chi
    text :ngay_sinh do 
      ngay_sinh.strftime("%d/%m/%Y")
    end    
    text :hoc_ky do 
      Tenant.first.hoc_ky
    end
    text :nam_hoc do 
      Tenant.first.nam_hoc
    end
  end
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

  def <=> other
     t1 = mycompare(self.ten, other.ten)
     t2 = mycompare(self.dem, other.dem)
     t3 = mycompare(self.ho, other.ho)
     t4 = self.ngay_sinh <=> other.ngay_sinh
     return t1 if t1 != 0
     return t2 if t2 != 0
     return t3 if t3 != 0
     return t4 if t4 != 0
     return 0
    end
  
  def trans(x)
  	(x ? x + " " : "")
  end
  

    def mycompare(s1, s2)
            if s1.nil? and s2 then return -1 end
            if s1 and s2.nil? then return 1 end
            if s1.nil? and s2.nil? then return 0 end
            s1 = s1.strip
            s2 = s2.strip
            
            if s1.length == 0 and s2.length == 0 then return 0 end
            if s1.length == 0 then return -1 end
            if s2.length == 0 then return 1 end
            
            ss = "AÀÁẢÃẠĂẰẮẲẴẶÂẦẤẨẪẬBCDĐEÈÉẺẼẸÊỀẾỂỄỆFGHIÌÍỈĨỊJKLMNOÒÓỎÕỌÔỒỐỔỖỘƠỜỚỞỠỢPQRSTUÙÚỦŨỤƯỪỨỬỮỰVWXYỲÝỶỸỴZ "
            ss2 = "aàáảãạăằắẳẵặâầấẩẫậbcdđeèéẻẽẹêềếểễệfghiìíỉĩịjklmnoòóỏõọôồốổỗộơờớởỡợpqrstuùúủũụưừứửữựvwxyỳýỷỹỵz "
                            
            minLength = s1.length
            if (minLength > s2.length) then minLength = s2.length end
            i = 0                                                                
            while i < minLength                         
                    ch1 = s1[i]
                    ch2 = s2[i]
                    
                    i1 = ss.index(ch1)                
                    i2 = ss.index(ch2)        
                    i1 = ss2.index(ch1) if i1.nil?
                    i2 = ss2.index(ch2) if i2.nil?
                    return -1 if i1 < i2
                    return 1 if i2 < i1
                    i += 1
            end        
            if i == s1.length and i == s2.length then return 0 end
            if i == s1.length then return -1 end
            if i == s2.length then return 1 end        
            return 0
    end
end
