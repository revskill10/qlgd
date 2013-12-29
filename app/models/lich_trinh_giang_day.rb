
class LichTrinhGiangDay < ActiveRecord::Base
  attr_accessible :lop_mon_hoc_id, :moderator_id, :noi_dung, :phong, :so_tiet, :state, :thoi_gian, :thuc_hanh, :tiet_bat_dau, :tiet_nghi, :tuan, :status, :giang_vien_id, :so_tiet_moi
  
  belongs_to :lop_mon_hoc
  belongs_to :giang_vien
  has_many :attendances, :dependent => :destroy
  has_many :enrollments, :through => :lop_mon_hoc
  validates :thoi_gian, :so_tiet, :giang_vien_id, :presence => true
  validate :check_thoi_gian, on: :create
  
  

  
  TIET = {[6,30] => 1, [7,20] => 2, [8,10] => 3,
    [9,5] => 4, [9,55] => 5, [10, 45] => 6,
    [12,30] => 7, [13,20] => 8, [14,10] => 9,
    [15, 5] => 10, [15, 55] => 11, [16, 45] => 12,
    [18, 0] => 13, [18, 50] => 14, [19,40] => 15, [20,30] => 16}
  
  TIET2 = {1 => [6,30], 2 => [7,20], 3 => [8,10],
    4 => [9,5], 5 => [9,55], 6 => [10, 45],
    7 => [12,30], 8 => [13,20], 9 => [14,10],
    10 => [15, 5], 11 => [15, 55], 12 => [16, 45],
    13 => [18, 0], 14 => [18, 50], 15 => [19,40], 16 => [20,30]}
  CA = {1 => [6,30], 2 => [9,5], 3 => [12,30], 4 => [15,5], 5 => [18,0], 6 => [20,30]}
  
  # state [normal, nghiday, nghile, bosung]  

  state_machine :status, :initial => :waiting do     
    event :accept do 
      transition all => :accepted # duoc chap nhan thuc hien
    end
    event :complete do 
      transition :accepted => :completed
    end
    event :queue do 
      transition all => :queued # dang cho xet duyet
    end
    event :drop do 
      transition :queued => :dropped # khong duoc xet duyet
    end    
  end


  def accept
    self.state ||= :normal
    self.tuan = self.load_tuan
    self.tiet_bat_dau = self.get_tiet_bat_dau
    self.so_tiet_moi = self.so_tiet
    super
  end

  
  def get_tiet_bat_dau
    hour = thoi_gian.localtime.hour
    minute = thoi_gian.localtime.min
    return TIET[[hour, minute]]
  end
  
  def load_tuan
    Tuan.all.detect {|t| t.tu_ngay <= thoi_gian.localtime.to_date and t.den_ngay >= thoi_gian.localtime.to_date }.stt    
  end
  def check_thoi_gian    
    t = lop_mon_hoc.lich_trinh_giang_days.where("thoi_gian = timestamp ?", thoi_gian.strftime('%Y-%m-%d %H:%M:00')).first
    unless t.nil?
      errors[:name] << 'duplicates thoi_gian'
    end
  end
  

end
