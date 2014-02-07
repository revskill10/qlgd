class Assistant < ActiveRecord::Base
  attr_accessible :lop_mon_hoc_id, :user_id, :giang_vien_id, :trogiang

  belongs_to :user
  belongs_to :lop_mon_hoc
  belongs_to :giang_vien
  
  scope :giang_vien_chinh, where("trogiang IS NULL or tro_giang = FALSE") 

  validates :giang_vien, :lop_mon_hoc, :presence => true

  def get_lichs
  	lop_mon_hoc.lich_trinh_giang_days.includes(:vi_pham).with_giang_vien(giang_vien.id)
  end

  def destroy
  	calendars = self.lop_mon_hoc.calendars.where(giang_vien_id: self.giang_vien_id)
    calendars.each do |c|
      c.destroy
    end
  	super
  end
end
