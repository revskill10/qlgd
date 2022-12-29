#encoding: utf-8
class LichTrinhGiangDay < ActiveRecord::Base

  include Comparable
  default_scope order('thoi_gian, phong')
  attr_accessible :lop_mon_hoc_id, :moderator_id, :noi_dung, :phong, :so_tiet, :state, :thoi_gian, :thuc_hanh, :tiet_bat_dau, :tiet_nghi, :tuan, :status, :giang_vien_id, :so_tiet_moi, :note, :ltype
  
  belongs_to :lop_mon_hoc
  belongs_to :giang_vien
  has_many :attendances, :dependent => :destroy
  has_many :enrollments, :through => :lop_mon_hoc, :uniq => true
  has_many :sinh_viens, :through => :enrollments, :uniq => true
  validates :thoi_gian, :so_tiet, :giang_vien_id, :state, :presence => true
  validate :check_thoi_gian, on: :create
  
  validate :check_state
  validates :giang_vien, :presence => true
  validates :so_tiet, :numericality => {:greater_than => 0}
  
  has_one :du_gio, :dependent => :destroy
  has_one :vi_pham, :dependent => :destroy
  scope :not_tuhoc, where("ltype != 'tuhoc'")
  scope :active, where(["thoi_gian > ? and thoi_gian < ?", Date.today.to_time.utc, Date.today.to_time.utc + 1.day])
  scope :accepted, where(status: :accepted)
  scope :thanhtra, where(status: ["accepted","completed"])
  scope :accepted_or_dropped, where(status: ["accepted", "dropped"])
  scope :accepted_or_dropped_or_completed, where(status: ["accepted", "dropped", "completed"])
  scope :completed, where(status: :completed)
  scope :accepted_or_completed, where(status: ["accepted","completed"], state: ["bosung","normal"])
  scope :waiting, where(status: :waiting)
  scope :with_giang_vien, lambda {|giang_vien_id| where(giang_vien_id: giang_vien_id)}
  scope :with_lop, lambda {|lop_mon_hoc_id| where(lop_mon_hoc_id: lop_mon_hoc_id)}
  scope :conflict, lambda {|lich| accepted.select {|m| lich.conflict?(m)}}
  scope :bosung, where(state: "bosung")
  scope :nghiday, where(state: "nghiday")
  scope :nghile, where(state: "nghile")
  scope :normal, where(state: "normal") 
  scope :normal_or_bosung, where(state: ["bosung","normal"]) 
  scope :daduyet, accepted_or_dropped_or_completed.where(state: ["bosung", "nghiday"])
  before_create :set_default
  after_save :set_tuhoc
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
  CA = {1 => Time.strptime('6:29','%H:%M'), 2 => Time.strptime('9:04','%H:%M'), 3 => Time.strptime('12:29','%H:%M'), 4 => Time.strptime('15:04','%H:%M'), 5 => Time.strptime('17:59','%H:%M'), 6 => Time.strptime('20:29','%H:%M')}
  CA2 = {1 => (CA[1]..CA[2]), 2 => (CA[2]..CA[3]), 3 => (CA[3]..CA[4]), 4 => (CA[4]..CA[5]), 5 => (CA[5]..CA[6])}

  FACETS = [:ma_lop, :ten_mon_hoc, :giang_vien, :phong, :tuan, :hoc_ky, :nam_hoc]
  searchable do
    text :noi_dung, :phong, :tuan, :hoc_ky, :nam_hoc, :ma_lop, :ten_mon_hoc, :ten_giang_vien
    text :thoi_gian do 
      thoi_gian.localtime.strftime("%d/%m/%Y")
    end
    string :ma_lop
    string :ten_mon_hoc
    string :ten_giang_vien
    string :hoc_ky      
    string :nam_hoc     
    string :tenant     
    text :attendances do
      if danh_sach_vangs.count > 0 
        danh_sach_vangs.map {|at| at.sinh_vien.hovaten + " " + at.sinh_vien.code}
      end
    end
  end  

  def ca    
    temp = LichTrinhGiangDay::CA2.detect {|k,v| v.cover?(Time.strptime("#{thoi_gian.localtime.hour}:#{thoi_gian.localtime.min}","%H:%M"))}
    temp[0]
  end
  def ma_lop
    self.lop_mon_hoc.ma_lop
  end
  def ten_mon_hoc
    self.lop_mon_hoc.ten_mon_hoc
  end
  def ten_giang_vien
    self.giang_vien.hovaten
  end
  def tenant
    Tenant.first.id.to_s
  end  
  def hoc_ky
    Tenant.first.hoc_ky
  end
  def nam_hoc
    Tenant.first.nam_hoc
  end
  # state [normal, nghiday, nghile, bosung]  
  
  state_machine :status, :initial => :waiting do     
    event :accept do 
      transition :waiting => :accepted, :if => lambda {|lich| ["nghile", "normal", "bosung", "nghiday"].include?(lich.state) } # khong duoc xet duyet # duoc chap nhan thuc hien
    end    
    event :complete do 
      transition :accepted => :completed, :if => lambda {|lich| ["bosung", "normal"].include?(lich.state) } # khong duoc xet duyet
    end    
    event :drop do 
      transition :waiting => :dropped, :if => lambda {|lich| ["bosung"].include?(lich.state) } # khong duoc xet duyet
    end
    event :remove do 
      transition [:waiting, :accepted] => :removed, :if => lambda {|lich| ["nghiday","normal", "bosung"].include?(lich.state) } # khong duoc xet duyet # xoa lich bo sung hoac lich chinh
    end
    event :restore do 
      transition :removed => :waiting, :if => lambda {|lich| ["nghiday","normal", "bosung"].include?(lich.state) } # khong duoc xet duyet
    end
    event :dtremove do
      transition all => :dtremoved
    end
    event :dtrestore do 
      transition :dtremoved => :waiting
    end
    event :uncomplete do 
      transition :completed => :accepted, :if => lambda {|lich| lich.state == "normal" or lich.state == "bosung"}
    end
  end


  def complete
    self.completed_at = Time.now
    super
  end
  def active?
    self.thoi_gian.localtime >= Date.today.to_time and self.thoi_gian.localtime < Date.tomorrow.to_time    
  end
  def can_nghiday?
    self.state == "normal" and [:waiting, :accepted].include?(self.status.to_sym)
  end
  def nghiday!
    return nil unless can_nghiday?
    self.state = "nghiday"
    self.status = "waiting"
  end
  def can_unnghiday?
    self.state == "nghiday" and self.status.to_sym == :waiting
  end
  def unnghiday!
    return nil unless can_unnghiday?
    self.state = "normal"
    self.status = "accepted"
  end

  def can_edit?
    ( (self.state == "bosung" and self.status == "waiting") or (self.state == "normal" and ["waiting", "accepted", "completed"].include?(self.status)) )
  end
  def can_edit_content?
    ( (self.state == "bosung" and self.status == "waiting") or (self.state == "normal" and ["waiting", "accepted", "completed"].include?(self.status)) )
  end
  
  def summary
    return "" unless self.noi_dung
    return self.noi_dung[0..20] + " ..."
  end
  
  def set_tuhoc

  end
  def alias_state
    case self.state
    when "normal"
      return "Bình thường"
    when "nghiday"
      return "Nghỉ dạy"
    when "nghile"
      return "Nghỉ lễ"
    when "bosung"
      return "Bổ sung"
    end
  end
  def color
    case self.state.to_sym
    when :normal
      return "success"
    when :bosung
      return "active"
    when :nghiday
      return "danger"
    when :nghile
      return "warning"    
    end
  end
  def color_status
    case self.status.to_sym
    when :waiting
      "label label-default"
    when :accepted
      "label label-primary"
    when :removed
      "label label-warning"
    when :completed
      "label label-success"
    when :dropped
      "label label-danger"
    end
  end
  def alias_status
    case self.status.to_sym
    when :waiting
      return "Đang chờ"
    when :accepted
      return "Được chấp nhận"
    when :removed
      return "Bị hủy"
    when :completed
      return "Đã hoàn thành"
    when :dropped
      return "Không được chấp nhận"
    end
  end

  def type_status
    case self.ltype 
    when "lythuyet"
      "Lý thuyết"
    when "thuchanh"
      "Thực hành"
    when "tuhoc"
      "Tự học"
    when "baitap"
      "Bài tập"
    end
  end

  def type_abbr
    case self.ltype 
    when "lythuyet"
      "LT"
    when "thuchanh"
      "TH"
    when "tuhoc"
      "TU"
    when "baitap"
      "BT"
    end
  end
  
  def get_tiet_bat_dau
    hour = thoi_gian.localtime.hour
    minute = thoi_gian.localtime.min
    return TIET[[hour, minute]]
  end
  # Co 2 loai conflict. 1 la khi 2 gio hoc cung thoi gian cung phong, 2 la khi  co 2 gio hoc trung thoi gian cung 1 giang vien
  # Khi dang ky bo sung, kiem tra ca 2 loai conflict
  def conflict?(lich)
    return false unless lich.accepted?
    return false if state == "nghiday" or state == "nghile"
    return false if lich.state == "nghiday" or lich.state == "nghile"
    return false if id == lich.id
    return false unless lich.thoi_gian.to_date == thoi_gian.to_date
    return false unless (phong == lich.phong or giang_vien_id == lich.giang_vien_id)
    return true if lich.tiet_bat_dau == tiet_bat_dau
   # if thoi_gian < lich.thoi_gian
    #  return (lich.tiet_bat_dau > tiet_bat_dau) and (lich.tiet_bat_dau < tiet_bat_dau + so_tiet_moi)
    #else
     # return (tiet_bat_dau > lich.tiet_bat_dau) and (tiet_bat_dau < lich.tiet_bat_dau + lich.so_tiet_moi)
    #end 
    return (thoi_gian < lich.thoi_gian ? ( (lich.tiet_bat_dau > tiet_bat_dau) and (lich.tiet_bat_dau < tiet_bat_dau + so_tiet_moi) ): ( (tiet_bat_dau > lich.tiet_bat_dau) and (tiet_bat_dau < lich.tiet_bat_dau + lich.so_tiet_moi) ) )
  end

  def conflict_sinh_vien?(lich)
    return false unless lich.accepted?
    return false if state == "nghiday" or state == "nghile"
    return false if lich.state == "nghiday" or lich.state == "nghile"
    return false if id == lich.id
    return false unless lich.thoi_gian.to_date == thoi_gian.to_date    
    return true if lich.tiet_bat_dau == tiet_bat_dau
   # if thoi_gian < lich.thoi_gian
    #  return (lich.tiet_bat_dau > tiet_bat_dau) and (lich.tiet_bat_dau < tiet_bat_dau + so_tiet_moi)
    #else
     # return (tiet_bat_dau > lich.tiet_bat_dau) and (tiet_bat_dau < lich.tiet_bat_dau + lich.so_tiet_moi)
    #end 
    return (thoi_gian < lich.thoi_gian ? ( (lich.tiet_bat_dau > tiet_bat_dau) and (lich.tiet_bat_dau < tiet_bat_dau + so_tiet_moi) ): ( (tiet_bat_dau > lich.tiet_bat_dau) and (tiet_bat_dau < lich.tiet_bat_dau + lich.so_tiet_moi) ) )
  end
  

  def load_tuan
    tmp = Tuan.all.detect {|t| t.tu_ngay <= thoi_gian.localtime.to_date and t.den_ngay >= thoi_gian.localtime.to_date }
    return nil unless tmp
    tmp.try(:stt)
  end

  def reported?
    return false unless self.vi_pham
    return self.vi_pham.reported?
  end
  
  def removed?
    return false unless self.vi_pham
    return self.vi_pham.removed?
  end

  def confirmed?
    return false unless self.vi_pham
    return self.vi_pham.confirmed?
  end

  def accepted?
    return false unless self.vi_pham
    return self.vi_pham.accepted?
  end

  def requested?
    return false unless self.vi_pham
    return self.vi_pham.requested?
  end

  def sv_vang
    self.attendances.where("state = 'absent'").count
  end
  def danh_sach_vangs
    self.attendances.includes(:sinh_vien).where("state = 'absent' or state = 'late'")
  end
  private
  
  def set_default    
    self.tuan = self.load_tuan
    self.tiet_bat_dau = self.get_tiet_bat_dau
    self.so_tiet_moi = self.so_tiet    
  end
  
  # tim tuan va trung lich  
  def check_thoi_gian
    unless load_tuan
      errors[:tuan] << 'nonexists'
    end    
    t = lop_mon_hoc.lich_trinh_giang_days.where("thoi_gian = timestamp ?", thoi_gian.strftime('%Y-%m-%d %H:%M:00')).first
    unless t.nil?
      errors[:thoi_gian] << 'duplicates'
    end
  end

  

  def check_state
    unless ["normal", "bosung", "nghiday", "nghile"].include?(self.state)
      errors[:state] << 'can not be nil'
    end
  end
end
