class GiangVien < ActiveRecord::Base
  attr_accessible :code, :dem, :ho, :ten, :ten_khoa

  has_one :user, :as => :imageable
  has_many :lop_mon_hocs, :dependent => :destroy

  def hovaten
  	return trans(ho) + trans(dem) + ten
  end

  private
  def trans(x)
  	(x ? x + " " : "")
  end
end
