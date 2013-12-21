class Attendance < ActiveRecord::Base
  attr_accessible :note, :phep, :so_tiet_vang, :state

  belongs_to :lich_trinh_giang_day
  belongs_to :sinh_vien

  validates :lich_trinh_giang_day, :sinh_vien, :presence => true
  state_machine :state, :initial => :pending do  
    #before_transition any => :absent, :do => :do_absent

    event :mark_absent do 
      transition :pending => :absent # vang ca buoi hoc
    end
    
    event :mark_late do 
      transition all => :late # di tre, vang 1 so buoi hoc
    end
    
    event :mark_present do 
      transition all => :present #co mat
    end

    event :mark_idle do 
      transition all => :idle # khong phai di hoc
    end
  end
  
  def mark_idle
    self.phep = nil
    self.so_tiet_vang = 0
    self.note = nil
    super
  end

  def mark_present
    self.phep = nil
    self.so_tiet_vang = 0
    super
  end


  def mark_absent(stv, phep)    
    self.phep = phep
    self.so_tiet_vang = stv
    #self.save!
    super
  end

  def mark_late(stv, phep)    
    self.phep = phep
    self.so_tiet_vang = stv
    #self.save!
    super
  end

  def mark(stv, phep, idle)
    return nil if stv.nil? or stv > lich_trinh_giang_day.so_tiet
    if idle == true
      mark_idle      
    end
    if stv == 0
      mark_present
    end
    if stv > 0 and stv < lich_trinh_giang_day.so_tiet
      mark_late(stv, phep)
    end
    if stv > 0 and stv == lich_trinh_giang_day.so_tiet
      mark_absent(stv, phep)
    end
    return true
  end
end
