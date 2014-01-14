#encoding: utf-8
class LopMonHoc < ActiveRecord::Base  
  serialize :settings
  attr_accessible :ma_lop, :ma_mon_hoc, :ten_mon_hoc


  validates :ma_lop, :ma_mon_hoc, :ten_mon_hoc, :presence => true
  
  has_many :calendars, :dependent => :destroy
  has_many :lich_trinh_giang_days, :dependent => :destroy
  has_many :giang_viens, :through => :calendars, :uniq => true
  has_many :enrollments, :dependent => :destroy
  has_many :results, :dependent => :destroy
  has_many :assignment_groups, :dependent => :destroy, :order => 'position'
  has_many :assignments
  has_many :submissions, :through => :assignments
  has_many :assistants, :dependent => :destroy
  has_many :users, :through => :assistants, :uniq => true
  scope :pending_or_started, where(state: ["pending","started"]) 

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
      assistants.map {|as| as.hovaten}
    end
    text :enrollments do
      enrollments.map { |enrollment| enrollment.sinh_vien.code + " " + enrollment.sinh_vien.hovaten }
    end    
    text :de_cuong_chi_tiet do 
      settings["de_cuong_chi_tiet"]
    end    
    text :hoc_ky do 
      Tenant.first.hoc_ky
    end
    text :nam_hoc do 
      Tenant.first.nam_hoc
    end
  end

  state_machine :state, :initial => :pending do  
    event :start do # da thiet lap thong so
      transition all  => :started
    end 
    event :complete do 
      transition :started => :completed # da ket thuc mon
    end
    event :remove do 
      transition :pending => :removed # 
    end
    event :restore do 
      transition :removed => :pending
    end
  end
  
  def start
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
    self.generate_calendars
    super
  end
  
  def khoi_luong_thuc_hien
    lich_trinh_giang_days.completed.sum(:so_tiet_moi)
  end

  def generate_calendars
    if calendars.count > 0 
      calendars.each do |calendar|
        calendar.generate unless calendar.generated?
      end
    end
  end
  
  def tong_so_tiet
    return 0 unless self.settings
    return (self.settings[:so_tiet_ly_thuyet] || 0) + (self.settings[:so_tiet_thuc_hanh] || 0) + (self.settings[:so_tiet_tu_hoc] || 0) + (self.settings[:so_tiet_bai_tap] || 0)
  end

  def tong_so_tiet_hoc
    return 0 unless self.settings
    return (self.settings[:so_tiet_ly_thuyet] || 0) + (self.settings[:so_tiet_thuc_hanh] || 0) + (self.settings[:so_tiet_bai_tap] || 0)
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
