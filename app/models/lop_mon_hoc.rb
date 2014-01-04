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
  
  state_machine :state, :initial => :pending do  
    event :start do # da thiet lap thong so
      transition all  => :started
    end 
    event :complete do 
      transition :started => :completed # da ket thuc mon
    end
    event :remove do 
      transition :pending => :removed
    end    
  end
  
  def start(gv)
    self.settings ||= {}
    self.settings[:generated] = false unless self.settings[:generated]
    self.settings[:so_tiet_ly_thuyet] ||= 0
    self.settings[:so_tiet_thuc_hanh] ||= 0
    self.generate_assignments(gv)
    super
  end
  

  def generate_calendars
    if calendars.count > 0 
      calendars.each do |calendar|
        calendar.generate
      end
    end
  end
  
  def tong_so_tiet
    return 0 unless self.settings
    return (self.settings[:so_tiet_ly_thuyet] || 0) + (self.settings[:so_tiet_thuc_hanh] || 0)
  end

  
  def generate_assignments(gv)
#    return nil unless self.started?
    return nil unless self.settings.present?
    return nil if self.settings.present? and self.settings[:generated] == true    
    ag1 = self.assignment_groups.create(name: "Điểm chuyên cần", weight: 40, giang_vien_id: gv.id)
    ag1.move_to_bottom
    as1 = self.assignments.create(name: "Điểm chuyên cần", points: 10, giang_vien_id: gv.id, assignment_group_id: ag1.id)
    as1.move_to_bottom
    ag2 = self.assignment_groups.create(name: "Điểm thực hành", weight: 30, giang_vien_id: gv.id)
    ag2.move_to_bottom
    as2 = self.assignments.create(name: "Điểm thực hành", points: 10, giang_vien_id: gv.id, assignment_group_id: ag2.id)
    as2.move_to_bottom
    ag3 = self.assignment_groups.create(name: "Điểm trung bình kiểm tra", weight: 30, giang_vien_id: gv.id)
    ag3.move_to_bottom
    as31 = self.assignments.create(name: "KT lần 1", points: 10, giang_vien_id: gv.id, assignment_group_id: ag3.id)
    as31.move_to_bottom
    as32 = self.assignments.create(name: "KT lần 2", points: 10, giang_vien_id: gv.id, assignment_group_id: ag3.id)
    as32.move_to_bottom
    as33 = self.assignments.create(name: "KT lần 3", points: 10, giang_vien_id: gv.id, assignment_group_id: ag3.id)
    as33.move_to_bottom
    self.settings[:generated] = true    
    self.save!
  end

  
end
