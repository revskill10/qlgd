class LopMonHoc < ActiveRecord::Base  
  serialize :settings
  attr_accessible :ma_lop, :ma_mon_hoc, :ten_mon_hoc


  validates :ma_lop, :ma_mon_hoc, :ten_mon_hoc, :presence => true
  
  has_many :calendars, :dependent => :destroy
  has_many :lich_trinh_giang_days, :dependent => :destroy
  has_many :giang_viens, :through => :calendars, :uniq => true
  has_many :enrollments, :dependent => :destroy
  has_many :results, :dependent => :destroy
  has_many :assignment_groups, :dependent => :destroy
  has_many :assignments, :dependent => :destroy
  has_many :submissions, :through => :assignments
  
  state_machine :state, :initial => :pending do  
    event :start do # da thiet lap thong so
      transition all => :started, :if => lambda {|lop| lop.settings != nil }
    end 
    event :complete do 
      transition :started => :completed # da ket thuc mon
    end
    event :remove do 
      transition :pending => :removed
    end
  end

  def start
    self.settings ||= {}
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
    return 0 unless settings
    return (settings["so_tiet_ly_thuyet"] || 0) + (settings["so_tiet_thuc_hanh"] || 0)
  end

end
