class GiangVien < ActiveRecord::Base
  attr_accessible :code, :dem, :ho, :ten, :ten_khoa

  has_one :user, :as => :imageable
  has_many :calendars, :dependent => :destroy
  has_many :lop_mon_hocs, :through => :calendars, :uniq => true
  has_many :lich_trinh_giang_days, :dependent => :destroy
  validates :code, :ho, :ten, :presence => true
  def hovaten
  	return trans(ho) + trans(dem) + ten
  end

  private
  def trans(x)
  	(x ? x + " " : "")
  end
end
