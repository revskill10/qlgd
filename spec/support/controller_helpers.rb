module ControllerMacros
  include Warden::Test::Helpers
  
  def login_admin    
    user = FactoryGirl.create(:admin) # Using factory girl as an example
    login_as(user, :scope => :user)    
  end

  def login_user     
    user = FactoryGirl.create(:user)
    user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the confirmable module
    login_as(user, :scope => :user)    
  end

  def login_sinhvien    
    user = FactoryGirl.create(:sinhvien)
    sv = FactoryGirl.create(:sinh_vien, :user => user)        
    login_as(user, :scope => :user)    
  end

  def login_giangvien    
    gv = FactoryGirl.create(:giang_vien, :user => nil)
    us = FactoryGirl.create(:giangvien, :imageable => gv)
    
    lop = FactoryGirl.create(:lop_mon_hoc, :giang_vien => gv)
    lop2 = FactoryGirl.create(:lop_mon_hoc, :ma_lop => "ml2", :giang_vien => gv)  
    login_as(us, :scope => :user)    
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.include ControllerMacros, :type => :controller
end