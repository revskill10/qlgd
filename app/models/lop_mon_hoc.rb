#encoding: utf-8
class LopMonHoc < ActiveRecord::Base  
  serialize :settings
  attr_accessible :ma_lop, :ma_mon_hoc, :ten_mon_hoc, :settings, :duyet_thong_so, :duyet_lich_trinh, :duyet_tinh_hinh


  validates :ma_lop, :ma_mon_hoc, :ten_mon_hoc, :presence => true
  
  has_many :calendars, :dependent => :destroy
  has_many :lich_trinh_giang_days, :dependent => :destroy
  has_many :giang_viens, :through => :calendars, :uniq => true
  has_many :enrollments, :dependent => :destroy  
  has_many :assignment_groups, :dependent => :destroy, :order => 'position'
  has_many :assignments
  has_many :submissions, :through => :assignments
  has_many :assistants, :dependent => :destroy
  has_many :giang_viens, :through => :assistants, :uniq => true
  has_many :users, :through => :assistants, :uniq => true

  scope :normal, where(state: ["pending","started","completed"]) 
  scope :pending_or_started, where(state: ["pending","started"]) 
  scope :started, where(state: "started")
  scope :select_all, select('id, ma_lop, ma_mon_hoc, ten_mon_hoc, state')
  FACETS = [:ma_lop, :ten_mon_hoc, :hoc_ky, :nam_hoc]
  searchable do
    text :ma_lop, :ten_mon_hoc, :de_cuong_chi_tiet
    text :lich_trinh_giang_days do
      lich_trinh_giang_days.map { |lich| lich.noi_dung }
    end    
    text :giang_viens do 
      giang_viens.map {|gv| gv.hovaten}
    end
    text :assistants do
      if assistants.count > 0 
        assistants.map {|as| as.giang_vien.hovaten}
      end
    end
    text :enrollments do
      if enrollments.count > 0
        enrollments.map { |enrollment| enrollment.sinh_vien.code + " " + enrollment.sinh_vien.hovaten }
      end
    end    
    text :de_cuong_chi_tiet do 
      settings["de_cuong_chi_tiet"] if settings and settings[:de_cuong_chi_tiet]
    end    
    text :lich_trinh_du_kien do 
      settings["lich_trinh_du_kien"] if settings and settings[:lich_trinh_du_kien]
    end
    text :hoc_ky do 
      Tenant.first.hoc_ky
    end
    text :nam_hoc do 
      Tenant.first.nam_hoc
    end
    string :tenant
  end
  def tenant
    Tenant.first.id.to_s
  end  

  state_machine :state, :initial => :pending do  
    event :start do # da thiet lap thong so
      transition all  => :started
    end 
    event :complete do 
      transition :started => :completed # da ket thuc mon
    end
    event :uncomplete do 
      transition :completed => :started
    end
    event :remove do 
      transition [:pending, :started] => :removed # 
    end
    event :restore do 
      transition :removed => :pending
    end
  end
  
  def start
    self.generate_calendars
    self.settings ||= {}
    self.settings[:generated] = false unless self.settings[:generated]
    self.settings[:so_tiet_ly_thuyet] ||= 0
    self.settings[:so_tiet_thuc_hanh] ||= 0
    self.settings[:so_tiet_tu_hoc] ||= 0
    self.settings[:so_tiet_bai_tap] ||= 0
    self.settings[:lich_trinh_du_kien] ||= ""
    self.settings[:de_cuong_chi_tiet] ||= ""
    self.settings[:language] ||= "vietnamese"
    self.generate_assignments    
    super
  end
  
  def remove
    self.calendars.each do |calendar|
      calendar.remove! if calendar.can_remove?
    end
    super
  end

  def restore
    self.calendars.each do |calendar|
      calendar.restore! if calendar.can_restore?
    end
    super
  end

  def khoi_luong_thuc_hien
    lich_trinh_giang_days.completed.sum(:so_tiet_moi)
  end

  def generate_calendars
    if calendars.count > 0 
      calendars.each do |calendar|
        calendar.generate! if calendar.can_generate?
      end
    end
  end
  
  def khoi_luong_du_kien
    lich_trinh_giang_days.accepted_or_completed.sum(:so_tiet_moi)
  end
  
  def tong_so_tiet
    return 0 unless self.settings
    return (self.settings[:so_tiet_ly_thuyet] || 0) + (self.settings[:so_tiet_thuc_hanh] || 0) + (self.settings[:so_tiet_tu_hoc] || 0) + (self.settings[:so_tiet_bai_tap] || 0)
  end

  

  def tong_so_tiet_hoc
    return 0 unless self.settings
    return (self.settings[:so_tiet_ly_thuyet] || 0) + (self.settings[:so_tiet_thuc_hanh] || 0) + (self.settings[:so_tiet_bai_tap] || 0)
  end

  def si_so
    self.enrollments.count
  end
  def teachers
    self.giang_viens.inject("") {|res, elem| res + "  " + elem.hovaten}
  end
  
  def generate_assignments
#    return nil unless self.started?
    return nil unless self.settings.present?
    return nil if self.settings.present? and self.settings[:generated] == true    
    ag1 = self.assignment_groups.create(name: "Điểm chuyên cần", weight: 40)
    ag1.move_to_bottom
    as1 = self.assignments.create(name: "Điểm chuyên cần", points: 10, assignment_group_id: ag1.id)
    as1.move_to_bottom
    ag2 = self.assignment_groups.create(name: "Điểm thực hành", weight: 30)
    ag2.move_to_bottom
    as2 = self.assignments.create(name: "Điểm thực hành", points: 10, assignment_group_id: ag2.id)
    as2.move_to_bottom
    ag3 = self.assignment_groups.create(name: "Điểm trung bình kiểm tra", weight: 30)
    ag3.move_to_bottom
    as31 = self.assignments.create(name: "KT lần 1", points: 10, assignment_group_id: ag3.id)
    as31.move_to_bottom
    as32 = self.assignments.create(name: "KT lần 2", points: 10, assignment_group_id: ag3.id)
    as32.move_to_bottom
    as33 = self.assignments.create(name: "KT lần 3", points: 10, assignment_group_id: ag3.id)
    as33.move_to_bottom
    self.settings[:generated] = true    
    self.save!
  end

  
end
