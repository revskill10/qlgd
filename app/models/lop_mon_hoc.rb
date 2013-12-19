class LopMonHoc < ActiveRecord::Base  
  serialize :settings
  attr_accessible :ma_lop, :ma_mon_hoc
  hstore_accessor :settings, :language


  validates :ma_lop, :ma_mon_hoc, :presence => true
  
  has_many :calendars, :dependent => :destroy
  has_many :lich_trinh_giang_days, :dependent => :destroy
  has_many :giang_viens, :through => :calendars, :uniq => true

  state_machine :state, :initial => :pending do   
    event :complete do 
      transition :pending => :completed
    end
    event :remove do 
      transition all => :removed
    end
  end



  def generate_calendars
    if calendars.count > 0 
      calendars.each do |calendar|
        calendar.generate
      end
    end
  end
  private
  def create_lichs
    generate_calendars
  end
end
