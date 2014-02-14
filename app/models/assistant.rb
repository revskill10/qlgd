class Assistant < ActiveRecord::Base
  attr_accessible :lop_mon_hoc_id, :user_id, :giang_vien_id, :trogiang

  belongs_to :user
  belongs_to :lop_mon_hoc
  belongs_to :giang_vien
  
  scope :giang_vien_chinh, where("trogiang IS NULL or trogiang = FALSE") 

  validates :giang_vien, :lop_mon_hoc, :presence => true

  def get_lichs
  	lop_mon_hoc.lich_trinh_giang_days.includes(:vi_pham).with_giang_vien(giang_vien.id)
  end
  def khoi_luong_thuc_hien
    self.lop_mon_hoc.lich_trinh_giang_days.where(giang_vien_id: self.giang_vien.id).completed.sum(:so_tiet_moi)
  end
  def khoi_luong_du_kien
    self.lop_mon_hoc.lich_trinh_giang_days.where(giang_vien_id: self.giang_vien.id).accepted_or_completed.sum(:so_tiet_moi)
  end
end
