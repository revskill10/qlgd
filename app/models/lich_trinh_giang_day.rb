class LichTrinhGiangDay < ActiveRecord::Base
  attr_accessible :lop_mon_hoc_id, :moderator_id, :noi_dung, :phong, :so_tiet, :state, :thoi_gian, :thuc_hanh, :tiet_bat_dau, :tiet_nghi, :tuan, :type
  
  belongs_to :lop_mon_hoc
  belongs_to :giang_vien
  validates :thoi_gian, :so_tiet, :presence => true
  validates :thoi_gian, :so_tiet, :uniqueness => true
  

  

  
  TIET = {1 => [6,30], 2 => [7,20], 3 => [8,10],
    4 => [9,5], 5 => [9,55], 6 => [10, 45],
    7 => [12,30], 8 => [13,20], 9 => [14,10],
    10 => [15, 5], 11 => [15, 55], 12 => [16, 45],
    13 => [18, 0], 14 => [18, 50], 15 => [19,40], 16 => [20,30]}
  CA = {1 => [6,30], 2 => [9,5], 3 => [12,30], 4 => [15,5], 5 => [18,0], 6 => [20,30]}
  def get_tiet_bat_dau
  	1
  end
  private
  
  def load_tuan
  	#Tuan.all.detect {|t| t.tu_ngay.localtime <= ngay_day.localtime and t.den_ngay.localtime >= ngay_day.localtime }.stt    
  end
  
end
