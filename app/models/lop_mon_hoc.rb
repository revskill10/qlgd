class LopMonHoc < ActiveRecord::Base  
  serialize :settings
  attr_accessible :ma_lop, :ma_mon_hoc
  hstore_accessor :settings, :language


  validates :ma_lop, :ma_mon_hoc, :presence => true
  
  has_many :calendars, :dependent => :destroy
  has_many :lich_trinh_giang_days, :dependent => :destroy
  has_many :giang_viens, :through => :calendars, :uniq => true
  has_many :enrollments, :dependent => :destroy

  state_machine :state, :initial => :pending do  
    event :start do 
      transition :pending => :started # da thiet lap thong so
    end 
    event :complete do 
      transition :started => :completed # da ket thuc mon
    end
    event :remove do 
      transition :pending => :removed
    end
  end



  def generate_calendars
    if calendars.count > 0 
      calendars.each do |calendar|
        calendar.generate
      end
    end
  end
    
end
