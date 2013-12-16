class SinhVien < ActiveRecord::Base
  attr_accessible :code, :dem, :ho, :ma_lop_hanh_chinh, :ngay_sinh, :ten

  has_one :user, :as => :imageable

  def hovaten
  	return trans(ho) + trans(dem) + ten
  end

  private
  def trans(x)
  	(x ? x + " " : "")
  end
end
