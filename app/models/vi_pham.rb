class ViPham < ActiveRecord::Base
  attr_accessible :bo_tiet, :di_muon, :lich_trinh_giang_day_id, :note1, :note2, :note3, :state, :ve_som

  belongs_to :lich_trinh_giang_day
  belongs_to :user
  validates :lich_trinh_giang_day, :presence => true

  state_machine :state, :initial => :waiting do     
    # :accepted, :removed, :confirmed
    event :accept do 
      transition :waiting => :accepted, :if => lambda {|vi_pham| ["normal", "bosung"].include?(vi_pham.lich_trinh_giang_day.state) } 
    end    
    event :request do 
      transition :waiting => :requested, :if => lambda {|vi_pham| ["normal", "bosung"].include?(vi_pham.lich_trinh_giang_day.state) } 
    end
    event :remove do
      transition [:waiting, :requested] => :removed, :if => lambda {|vi_pham| ["normal", "bosung"].include?(vi_pham.lich_trinh_giang_day.state) } 
    end
    event :confirm do
      transition [:waiting, :requested] => :confirmed, :if => lambda {|vi_pham| ["normal", "bosung"].include?(vi_pham.lich_trinh_giang_day.state) } 
    end
    event :report do 
      transition [:waiting, :requested] => :waiting, :if => lambda {|vi_pham| ["normal", "bosung"].include?(vi_pham.lich_trinh_giang_day.state) }
    end
	end
end
