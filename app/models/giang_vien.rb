class GiangVien < ActiveRecord::Base
  attr_accessible :code, :dem, :ho, :ten, :ten_khoa, :encoded_position

  has_one :user, :as => :imageable
  has_many :calendars, :dependent => :destroy
  #has_many :lop_mon_hocs, :through => :calendars, :uniq => true
  has_many :lich_trinh_giang_days, :dependent => :destroy
  has_many :khoas, :dependent => :destroy
  validates :code, :ho, :ten, :presence => true
  has_many :assistants, :dependent => :destroy
  has_many :lop_mon_hocs, :through => :assistants, :uniq => true
  def hovaten
  	return trans(ho) + trans(dem) + ten
  end
  
  private
  def trans(x)
  	(x ? x + " " : "")
  end
end
