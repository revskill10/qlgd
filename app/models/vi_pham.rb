class ViPham < ActiveRecord::Base
  attr_accessible :bo_tiet, :di_muon, :lich_trinh_giang_day_id, :note1, :note2, :note3, :state, :ve_som

  belongs_to :lich_trinh_giang_day
  belongs_to :user
  validates :lich_trinh_giang_day, :presence => true

  state_machine :state, :initial => :pending do     
    # :accepted, :removed, :confirmed
    event :accept do 
      transition [:reported, :requested] => :accepted, :if => lambda {|vi_pham| ["normal", "bosung"].include?(vi_pham.lich_trinh_giang_day.state) } 
    end    
    event :request do 
      transition [:reported, :requested] => :requested, :if => lambda {|vi_pham| ["normal", "bosung"].include?(vi_pham.lich_trinh_giang_day.state) } 
    end
    event :remove do
      transition [:pending, :reported, :requested] => :removed, :if => lambda {|vi_pham| ["normal", "bosung"].include?(vi_pham.lich_trinh_giang_day.state) } 
    end
    event :confirm do
      transition [:pending, :reported, :requested] => :confirmed, :if => lambda {|vi_pham| ["normal", "bosung"].include?(vi_pham.lich_trinh_giang_day.state) } 
    end
    event :report do 
      transition [:pending, :requested] => :reported, :if => lambda {|vi_pham| ["normal", "bosung"].include?(vi_pham.lich_trinh_giang_day.state) }
    end
    event :unreport do 
      transition :reported => :pending, :if => lambda {|vi_pham| ["normal", "bosung"].include?(vi_pham.lich_trinh_giang_day.state) }
    end
    event :restore do 
      transition [:removed, :confirmed] => :pending, :if => lambda {|vi_pham| ["normal", "bosung"].include?(vi_pham.lich_trinh_giang_day.state) }
    end
	end


  
end
