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
    user = FactoryGirl.create(:giangvien)
    gv = FactoryGirl.create(:giang_vien, :user => user)      
    login_as(user, :scope => :user)    
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.include ControllerMacros, :type => :controller
end